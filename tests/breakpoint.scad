// The swab's body between z = 8.8 and 9.2 mm. The breakpoint hole is centred at
// z = 9 mm (base_height 8 + body_breakpoint_height 1) with a 0.175 mm radius,
// so the whole hole falls inside this slice, and moving or resizing it changes
// the slice's volume.
use <../cad/nasal_swab.scad>

intersection()
{
    nasal_swab();
    translate([ -5, -5, 8.8 ]) cube([ 10, 10, 0.4 ]);
}
