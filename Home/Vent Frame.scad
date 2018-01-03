include <MCAD/units.scad>

dim_y = 56*mm;
dim_x = 10*mm;
dim_z = 30*mm;

slot_x_1 = 3.8*mm;

slot_y = 41*mm;
slot_bottom_y = 36*mm;
slot_x = 1.9*mm;
slot_z = 12.5*mm;

slot_relief_r = 2*mm;

snap_d_y = 1.00*inch;
snap_z = 7.6*mm;
snap_z_h = 5*mm;
snap_prot_x = 1*mm;
snap_y = 5.5*mm;

module snap() 
    translate([0,snap_y/2])
    rotate([0,0,180])
    linear_extrude(height = snap_z_h, scale=[0,1])
    square(size = [snap_prot_x, snap_y]);

difference() {
    translate([-dim_x+slot_x_1,-dim_y/2, -dim_z]) cube(size = [dim_x, dim_y, dim_z]);

    for(i=[0:1])
        mirror([0,i,0])
        rotate([0,180])
        linear_extrude(height = slot_z, scale=[1,slot_bottom_y/slot_y])
        square(size = [slot_x, slot_y/2]);
}

for (y = [-snap_d_y/2, snap_d_y/2])
    translate([0,y,-snap_z]) snap();
