// Hexagonal washer for a lamp. The threaded pipe goes into the middle.
include <mcad/units.scad>;
D = 38*mm;
d = 10*mm;
h = 3.5*mm;
linear_extrude(h) difference() {
    circle(d=D, $fn=6);
    circle(d=d);
    translate([0, -d/2]) square([2*d, d]);
}