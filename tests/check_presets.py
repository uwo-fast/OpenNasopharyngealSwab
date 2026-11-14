"""Render each Customizer preset, and the breakpoint slice, and check their sizes and volumes.

usage: python3 tests/check_presets.py [OPENSCAD]

Each preset in cad/nasal_swab.json, and tests/breakpoint.scad, is rendered
with --hardwarnings, so any warning fails the check. The breakpoint slice
holds the hole the swab breaks at, so moving or resizing the hole changes its
volume even where the whole swab's size and volume would not show it. Sizes are checked to within 0.01 mm and volumes to
within 0.01 mm³: widening the breakpoint hole from 0.175 to 0.2 mm radius takes
about 0.03 mm³ off the swab, and renders on the pinned OpenSCAD repeat to
0.001 mm³. A different OpenSCAD can mesh curves differently, so moving the pin
may mean re-measuring these values.

OpenSCAD renders the defaults when it is given a preset name the file doesn't
have, so every preset in the file must be listed here and
every one listed here must be in the file.
"""

import json
import os
import struct
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCAD = os.path.join(ROOT, "cad", "nasal_swab.scad")
BREAKPOINT = os.path.join(ROOT, "tests", "breakpoint.scad")
PRESETS = os.path.join(ROOT, "cad", "nasal_swab.json")

# preset: (size x, y, z in mm, volume in mm³), from OpenSCAD 2026.10.15
EXPECTED = {
    "nasal_swab_bullet_tip": ((3.472, 5.0, 81.246), 174.823),
    "nasal_swab_cone_tip": ((3.472, 5.0, 81.25), 174.065),
    "lock_handle": ((3.0, 15.0, 84.5), 3445.726),
}

# the body between z = 8.8 and 9.2 mm, around the breakpoint hole at 9 mm
BREAKPOINT_EXPECTED = ((1.013, 1.065, 0.4), 0.209)


def measure(path):
    data = open(path, "rb").read()
    (n,) = struct.unpack_from("<I", data, 80)
    lo, hi, volume = [float("inf")] * 3, [float("-inf")] * 3, 0.0
    for i in range(n):
        v = struct.unpack_from("<9f", data, 84 + i * 50 + 12)
        a, b, c = v[0:3], v[3:6], v[6:9]
        volume += (
            a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])
        ) / 6
        for p in (a, b, c):
            for k in range(3):
                lo[k], hi[k] = min(lo[k], p[k]), max(hi[k], p[k])
    return [h - l for h, l in zip(hi, lo)], volume


def main():
    openscad = sys.argv[1] if len(sys.argv) > 1 else "openscad"
    in_file = set(json.load(open(PRESETS))["parameterSets"])
    failures = []
    if in_file != set(EXPECTED):
        failures.append(f"presets in the file {sorted(in_file)} != checked {sorted(EXPECTED)}")
    checks = [(name, ["-p", PRESETS, "-P", name, SCAD], expected)
              for name, expected in EXPECTED.items()]
    checks.append(("breakpoint slice", [BREAKPOINT], BREAKPOINT_EXPECTED))
    with tempfile.TemporaryDirectory() as tmp:
        for name, args, (size, volume) in checks:
            out = os.path.join(tmp, name.replace(" ", "_") + ".stl")
            cmd = [openscad, "--hardwarnings", "--export-format", "binstl", "-o", out] + args
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode != 0:
                errors = [l for l in result.stderr.splitlines() if "WARNING" in l or "ERROR" in l]
                failures.append(f"{name}: openscad exited {result.returncode}: {'; '.join(errors)}")
                continue
            got_size, got_volume = measure(out)
            ok = all(abs(g - e) <= 0.01 for g, e in zip(got_size, size)) and \
                abs(got_volume - volume) <= 0.01
            sizes = " x ".join(f"{g:.3f}" for g in got_size)
            print(f"{'ok  ' if ok else 'FAIL'} {name}: {sizes} mm, {got_volume:.3f} mm³")
            if not ok:
                expected = " x ".join(f"{e:.3f}" for e in size)
                failures.append(f"{name}: expected {expected} mm, {volume:.3f} mm³")
    for f in failures:
        print("FAIL", f)
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
