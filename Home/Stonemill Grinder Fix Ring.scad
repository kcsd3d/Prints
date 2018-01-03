include <MCAD/units.scad>

ID = 44.8*mm;
t = 2*mm;
h = 15*mm;

difference() {
    $fn = 180;
    cylinder(d=ID+2*t, h=h);
    cylinder(d=ID, h=h);
}