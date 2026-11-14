// OS nasal swab
// 20-4-21
// Adam Pringle
// MOST group at MTU
//
// Cameron K. Brooks
// Formatting and organizing
// FAST Research Group at UWO

// All units are in metric and mm unless otherwise specified

// Render the desired object by changing the name of the render variable
render = "nasal_swab"; // ["nasal_swab", "lock_handle", "both"]

// Tip type: Select the tip geometry type
tip_type = "bullet"; // ["bullet", "cone"]

if (render == "nasal_swab")
{
    nasal_swab();
}
else if (render == "lock_handle")
{
    lock_handle();
}
else if (render == "both")
{
    lock_handle();
    nasal_swab();
}

// Settings for contours and curve resolution
$fa = 0.5;  // minimum angle for a fragment,, recommended:0.5
$fs = 0.15; // minimum size of a fragment, recommended: 0.5 is for changing variables, 0.15 should be used for final
            // render

//[Tip settings] --------------------------------------------------------------------------------------------
tip_height = 16.25;  // Length of the tip height, recommended:16.25
tip_radius = 1.125;  // Radius of the tip body section, recommended:1.125

tip_arm_radius = 1.5;        // Max radius of the tip arms, recommended:1.5
tip_arm_thickness = .5;      // diameter of the tip arm cylinders, recommended:0.5
tip_arm_spread = .5;         // distance between layers of arms, recommended:0.5
tip_arm_count = 5;           // Number of arms per layer 360/count, recommended:3 or 5
tip_arm_rotation_angle = 90; // angle of rotation of arms layer to layer, recommended:90

tip_taper_low_height = 5; // Height of the taper region towards the body, recommended:5

tip_taper_top_height = 4; // Height of the taper region towards the top, recommended:4
tip_taper_top_R1 = 1;     // radius of top cylinder for subtraction at the top tip, recommended:1
tip_taper_bot_R2 = 1.5;   // radius of bot cylinder for subtraction at the top tip, recommended:1.5

// cone_tip
tip_point_height = 1.5;                // Height of the pointed section at the top of the tip, recommended:1
tip_point_radius_top = .25;            // radius of the top of the tip point, recommended:0.25
tip_point_radius_bot = tip_radius + 0; // radius of the bottom of the tip point, recommended:tip_radius+0.25

// bullet_tip
tip_point_radius_bullet = 1.15; // radius of the bullet tip, recommended:1.15

//[Body settings] --------------------------------------------------------------------------------------------
body_height = 55.5; // Height of the single-use body section, recommended:55.5
body_radius = 0.56; // radius of the single-use body section - match with base_taper_radius, recommended:0.56

body_breakpoint_radius = 0.175; // radius of the throughhole to ensure breaking at the weakpoint, recommended:0.1
body_breakpoint_height = 1;     // distance of breakpoint from the tapered section, recommended:1

//[base settings] --------------------------------------------------------------------------------------------
base_type = "lock";       //[spring, lock] select the base geometry type - only lock has been designed
base_height = 8;          // Height of the single-use body section, recommended:8
base_radius = 1.25;       // radius of the single-use body section, recommended:1.25
base_taper_radius = 0.56; // radius of the base taper - match with body_radius, recommended:0.56
base_taper_height = 2.5;  // length of the base height which tapers to the taper radius, recommended:2.5

base_flat_height =
    5; // length of the flat section on the bottom of the base use with spring base geometry, recommended:5
base_lock_length = 5;   // length of the L-shape locking mechanism, recommended:5
base_lock_height = 1.5; // height of the L-shape locking mechanism, recommended:1.5

//[handle settings] --------------------------------------------------------------------------------------------
handle_X_thickness = 1;             // thickness of handle under base insert in X direction, recommended:1
handle_X_width = base_radius + .75; // width of the handle section in total, recommended:base_radius+0.75
handle_Y_length = 15;               // length of the handle section, recommended:15
handle_Z_height = 85;               // handle height for gripping by people, recommended:85
handle_pin_hole_radius = .5;        // radius of the pinhole to ensure base is easy to pop, recommended:0.5

OSHW_logo_subtraction = 5;
OSHW_logo_diameter = 12.5;

handle_text_Z = -handle_Z_height * .05;
handle_text_Y = -handle_Y_length * .15;
handle_text_size = 5.5;
handle_text = "OS SWABSTER";

// module for construction of nasal_swab
module nasal_swab()
{
    color("yellow") if (tip_type == "cone")
    {

        cone_tip();
    }
    else if (tip_type == "bullet")
    {

        bullet_tip();
    }

    // color("purple")
    tip();

    color("blue") body();

    color("green") if (base_type == "spring")
    {

        spring_base();
    }
    else if (base_type == "lock")
    {

        lock_base();
    }
    // color("red")

} // end of module nasal_swab

module cone_tip()
{
    translate([ 0, 0, tip_height + tip_point_height / 2 + body_height + base_height ])
        cylinder(tip_point_height, tip_point_radius_bot, tip_point_radius_top, true);

} // end of module cone_tip

module bullet_tip()
{
    translate([ 0, 0, tip_height + tip_point_height / 2 + body_height + base_height ])

        hull()
    {
        translate([ 0, 0, tip_point_height / 2 - tip_point_radius_bullet / 2 ]) sphere(tip_point_radius_bullet / 2);

        translate([ 0, 0, -tip_point_height / 2 + tip_point_height * 0.1 ])
            cylinder(tip_point_height * 0.2, tip_point_radius_bot, tip_point_radius_bot, true);
    }
} // end of module bullet_tip

module tip()
{

    translate([ 0, 0, +body_height + base_height ])
    {

        difference()
        {
            color("purple") union()
            {
                translate([ 0, 0, tip_height / 2 ]) cylinder(tip_height, tip_radius, tip_radius, true);

                for (x = [tip_taper_low_height * .05:tip_height / (tip_arm_spread + tip_arm_thickness)]) // numb
                    translate([ 0, 0, (tip_arm_spread + tip_arm_thickness) * x - tip_arm_thickness / 2 ])
                        rotate([ 0, 0, 90 * x ]) for (x = [0:tip_height]) // # of arms on each layer
                        rotate([ 0, 0, 360 / tip_arm_count * x ])

                            hull()
                    {
                        translate([ tip_arm_radius, 0, 0 ]) sphere(tip_arm_thickness / 2);
                        translate([ -tip_arm_radius, 0, 0 ]) sphere(tip_arm_thickness / 2);
                    }
            }
            color("red")
                // top section taper towards tip tip
                translate([ 0, 0, tip_height ]) difference()
            {

                cylinder(tip_taper_top_height + .01, tip_arm_radius * 2 + .01, tip_arm_radius * 2 + .01, true);
                cylinder(tip_taper_top_height + .02, tip_taper_bot_R2, tip_taper_top_R1, true);
            }

            color("red")
                // bot section taper towards tip bottom
                translate([ 0, 0, tip_taper_low_height / 2 - tip_arm_thickness ]) difference()
            {

                cylinder(tip_taper_low_height + .01, tip_arm_radius * 2 + .01, tip_arm_radius * 2 + .01, true);
                cylinder(tip_taper_low_height + .02, body_radius, tip_arm_radius + .01, true);
            }
        }
    }
} // end of module tip

module spring_base() // bottom, blue section
{
    // taper section
    translate([ 0, 0, base_height / 2 + base_height / 2 - base_taper_height / 2 ])
        cylinder(base_taper_height, base_radius, base_taper_radius, true);

    // base section
    difference()
    {
        translate([ 0, 0, base_height / 2 - base_taper_height / 2 ])
            cylinder(base_height - base_taper_height, base_radius, base_radius, true);

        translate([ 0, base_radius, base_flat_height / 2 ])
            cube([ base_radius * 2, base_radius, base_flat_height + .01 ], true);
    }
} // end of module base

module lock_base() // bottom, blue section
{
    // taper section
    translate([ 0, 0, base_height / 2 + base_height / 2 - base_taper_height / 2 ])
        cylinder(base_taper_height, base_radius, base_taper_radius, true);

    // base section

    translate([ 0, 0, base_height / 2 - base_taper_height / 2 ])
        cylinder(base_height - base_taper_height, base_radius, base_radius, true);

    translate([ 0, 0, base_lock_height / 2 ]) cube([ base_radius * 2, base_lock_length, base_lock_height ], true);
}

module body()
{

    difference()
    {

        translate([ 0, 0, body_height / 2 + base_height ]) cylinder(body_height, body_radius, body_radius, true);

        translate([ 0, 0, 0 + base_height + body_breakpoint_height ]) rotate([ 90, 0, 0 ])
            cylinder(body_radius * 5, body_breakpoint_radius, body_breakpoint_radius, true, $fn = 15);
    }

} // end of module body

// OSHW logo 2D
module gear_tooth_2d(d)
{
    polygon(points =
                [ [ 0.0, 10.0 * d / 72.0 ], [ 0.5 * d, d / 15.0 ], [ 0.5 * d, -d / 15.0 ], [ 0.0, -10.0 * d / 72.0 ] ]);
}

module oshw_logo_2d(d = 10.0)
{
    rotate(-135)
    {
        difference()
        {
            union()
            {
                circle(r = 14.0 * d / 36.0, $fn = 20);
                for (i = [1:7]){
					rotAngle = 45 * i + 45;
                    rotate(rotAngle) gear_tooth_2d(d);
				}

            }
            circle(r = 10.0 * d / 72.0, $fn = 20);
            intersection()
            {
                rotate(-20) square(size = [ 10.0 * d / 18.0, 10.0 * d / 18.0 ]);
                rotate(20) square(size = [ 10.0 * d / 18.0, 10.0 * d / 18.0 ]);
            }
        }
    }
}

// module for construction of the lock_handle
module lock_handle()
{

    difference()
    {
        translate([ handle_X_width / 2 - handle_X_thickness / 2, 0, 0 ]) color("orange") hull()
        {
            translate([ 0, 0, -handle_Z_height + base_height + handle_Y_length / 2 ]) rotate([ 0, 90, 0 ])
                cylinder(handle_X_width + handle_X_thickness, handle_Y_length / 2, handle_Y_length / 2, true);

            translate([ 0, 0, 0 ]) rotate([ 0, 90, 0 ])
                cylinder(handle_X_width + handle_X_thickness, handle_Y_length / 2, handle_Y_length / 2, true);
        }
        color("red") translate([ base_radius, 0, 0 ])
        {
            // taper section
            hull()
            {
                translate([ 0, 0, base_height / 2 + base_height / 2 - base_taper_height / 2 ])
                    cylinder(base_taper_height + .01, base_radius, base_taper_radius, true);

                translate([ base_radius * 5, 0, base_height / 2 + base_height / 2 - base_taper_height / 2 ])
                    cylinder(base_taper_height + .01, base_radius, base_taper_radius, true);
            }

            // base section
            hull()
            {
                translate([ 0, 0, base_height / 2 - base_taper_height / 2 ])
                    cylinder(base_height - base_taper_height, base_radius, base_radius, true);

                translate([ base_radius * 5, 0, base_height / 2 - base_taper_height / 2 ])
                    cylinder(base_height - base_taper_height, base_radius, base_radius, true);
            }

            hull()
            {
                translate([ 0, 0, base_lock_height / 2 ])
                    cube([ base_radius * 2, base_lock_length, base_lock_height ], true);

                translate([ base_radius * 5, 0, base_lock_height / 2 ])
                    cube([ base_radius * 2, base_lock_length, base_lock_height ], true);
            }
        }

        // creating pinhole for popout
        translate([ 0, 0, base_height * .4 ]) rotate([ 0, 90, 0 ])
            cylinder(base_radius * 5, handle_pin_hole_radius, handle_pin_hole_radius, true);

        color("red")
            // subtracting in the OSHW logo
            translate([ base_radius / 2, 0, -handle_Z_height + base_height + handle_Y_length / 2 ]) rotate([ 90, 0, 0 ])
                rotate([ 0, 90, 0 ]) linear_extrude(OSHW_logo_subtraction) oshw_logo_2d(OSHW_logo_diameter);
        color("red")
            // Adding in text on the handle
            translate([ base_radius * 1, handle_text_Y, handle_text_Z ]) rotate([ 0, 90, 0 ])
                linear_extrude(OSHW_logo_subtraction) text(handle_text, size = handle_text_size);
    }
} // end of module lock_handle