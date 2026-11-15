# Licensing

The paper this design comes from (Gallup et al. 2020, *HardwareX* 8, e00135)
releases it under the GNU General Public License v3.0 and the CERN Open Hardware
Licence v1.2, in its specifications table. Its design-files table lists each file
(the swab, handle and tong-handle meshes and the OpenSCAD source) as GPL-3.0. This
repository applies both licences to the design, and the GPL alone to its own
tooling:

| Files | Licence |
| --- | --- |
| `cad/` (the OpenSCAD source, its presets, the meshes and the slicer profile), `docs/`, `README.md`, `CITATION.cff` | GPL-3.0 and CERN OHL v1.2 |
| `tests/`, `justfile`, `.github/`, `.gitattributes`, `.gitignore` | GPL-3.0 |

The texts are in [`LICENSES/`](LICENSES): [`GPL-3.0.txt`](LICENSES/GPL-3.0.txt)
and [`CERN-OHL-1.2.txt`](LICENSES/CERN-OHL-1.2.txt). The root [`LICENSE`](LICENSE)
is the same GPL-3.0 text, because GitHub reads only that file.

The original release in
[ngallup4/Nasal-Swab-Files](https://github.com/ngallup4/Nasal-Swab-Files) carries
the notice "Copyright (c) 2020 ngallup4" and names "GNU GPL v3. CERN License"
without a version for the CERN licence; the version here is the paper's.
