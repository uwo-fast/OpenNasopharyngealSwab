# Licensing

The paper this design comes from (Gallup et al. 2020, *HardwareX* 8, e00135)
releases it under the GNU General Public License v3.0 and the CERN Open Hardware
Licence v1.2. It doesn't say which files each covers. This repository applies
them as follows:

| Files | Licence |
| --- | --- |
| `cad/nasal_swab.scad`, `cad/nasal_swab.json` (the parametric source and its presets) | GPL-3.0 and CERN OHL v1.2 |
| `cad/*.stl`, `cad/nasal_swab_sl1.ini` (the meshes and the slicer profile), `docs/` images | CERN OHL v1.2 |
| `tests/`, `justfile`, `.github/` (the render checks) | GPL-3.0 |
| `README.md`, `CITATION.cff` | GPL-3.0 and CERN OHL v1.2 |

The texts are in [`LICENSES/`](LICENSES): [`GPL-3.0.txt`](LICENSES/GPL-3.0.txt)
and [`CERN-OHL-1.2.txt`](LICENSES/CERN-OHL-1.2.txt). The root [`LICENSE`](LICENSE)
is the same GPL-3.0 text, because GitHub reads only that file.

The original release in
[ngallup4/Nasal-Swab-Files](https://github.com/ngallup4/Nasal-Swab-Files) names
"GNU GPL v3. CERN License" without a version for the CERN licence; the version
here is the paper's.
