p_tk = 2;
h_d = 2.1;
Off_X = 5;
Off_Y = 5;
b_tk = 1.6;

ext = 0.1;
$fn = 30;

module plate()
{
    translate([ 0, 0, -p_tk / 2 ]) difference()
    {
        translate([ -p_tk, -p_tk, 0 ]) cube([ (Off_X + h_d + 3) + p_tk, (Off_Y + h_d + 3) + p_tk, p_tk ]);
        translate([ Off_X, Off_Y, -ext ]) cylinder(h = p_tk + ext * 2, d = h_d);
    }
}

module p_1x2()
{
    plate();
    mirror([ 0, 1, 0 ]) plate();
}

module e_1x2()
{
    plate();
    translate([ 0, -p_tk / 2 - b_tk, p_tk / 2 + b_tk ]) rotate([ 90, 0, 0 ]) plate();
    translate([ -p_tk, -p_tk - b_tk, -p_tk / 2 ]) cube([ Off_X + h_d + 3 + p_tk, p_tk + b_tk, p_tk + b_tk ]);
}

module p_2x2()
{
    p_1x2();
    mirror([ 1, 0, 0 ]) p_1x2();
}

module e_2x2()
{
    e_1x2();
    mirror([ 1, 0, 0 ]) e_1x2();
}

module corner()
{
    plate();

    translate([ -p_tk / 2 - b_tk, 0, p_tk / 2 + b_tk ]) rotate([ 0, -90, 0 ]) plate();

    translate([ 0, -p_tk / 2 - b_tk, p_tk / 2 + b_tk ]) rotate([ 90, 0, 0 ]) plate();
    translate([ -p_tk, -p_tk - b_tk, -p_tk / 2 ]) cube([ Off_X + h_d + 3 + p_tk, p_tk + b_tk, p_tk + b_tk ]);
    translate([ -p_tk - b_tk, -p_tk, -p_tk / 2 ]) cube([ p_tk + b_tk, Off_X + h_d + 3 + p_tk, p_tk + b_tk ]);

    translate([ -p_tk - b_tk, -p_tk - b_tk, -p_tk / 2 ])
        cube([ p_tk + b_tk, p_tk + b_tk, Off_X + h_d + 3 + p_tk * 1 + b_tk ]);
}

e_2x2();