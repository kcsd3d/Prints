// Friction sleeves for the Mars Bars Shuttle model printed at certain scale
include <mcad/units.scad>

OD = 9.25*mm;   // Pin diameter
ID = 12.05*mm;  // Hole diameter
L = 8*mm;       // Length of the interface within the hole
FD = 14*mm;     // Flange diameter
fl = 2*mm;      // Flange thickness

eps = 1e-3*mm;
$fn = 4*15;

module sleeve(ODadj = 0, IDadj = 0) {
    difference() {
        union() {
            cylinder(d = ID+IDadj, h = L);
            translate([0,0,-fl]) cylinder(d = FD, h = fl);
        }
        translate([0,0,-fl-eps]) cylinder(d = OD+ODadj, h = fl+L+2*eps);
    }
}

// The sleeve should be tight on OD (pin), but should be loose-r in the hole.
ODs = [for (d=[-1:2]) OD + d*0.1*mm];
IDs = [for (d=[-3:1]) ID + d*0.1*mm];
sizes = [for (od=ODs, id=IDs) [od,id]];
N = len(sizes);
copies = 2;

n = N*copies;
columns = floor(sqrt(n));
step_l = FD + 1*mm;
i = 0;
for (j = [0:n-1]) {
    i = floor(j/copies);
    size = sizes[i];
    step = step_l*[j%columns, floor(j/columns)];
    translate(step) sleeve(OD-size[0], ID-size[1]);
}
//sleeve();