include <MCAD/units.scad>

$fa = 0.5;
D = 76.0*mm;

h_d1 = 10*mm;
h_d2 = 15*mm;
h_z = 20*mm;

module top() {
    difference() {
        bottom(flat=true);
        translate([0,0,D/2-h_z])
            linear_extrude(height=h_z, scale=(h_d1/h_d2)*[1,1])
            circle(d=h_d2);
    }
}

module bottom(flat=false)
    mirror([0, 0, flat ? 1:0]) difference() {
        sphere(d=D);
        translate([-D/2,-D/2,0]) cube(size=[D,D,D/2]);
    }

if (true) top(); else bottom(flat=true);