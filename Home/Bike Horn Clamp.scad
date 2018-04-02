include <mcad/units.scad>

$fa = 360/4/45;
$fs = 0.5*mm;

// horn diameter
D_h = 17.0*mm;
// horn ring thickness
t_h = 4*mm;
// horn ring length
l_h = 18.9*mm;
// horn ring cone rim width
r_h = 1*mm;
// horn setscrew clearance hole depth
c_h = 3.5*mm;
// horn setscrew clearance hole diameter
d1_h = 5.1*mm;
// horn setscrew threadable hole diameter
d0_h = 4.5*mm;

// horn-to-handlebar inner surface tangential distance
t_hH = 10*mm;

// handlebar diameter
D_H = 23.0*mm;
// handlebar ring thickness
t_H = 2.5*mm;
// handlebar clamp width (axial)
wc_H = 14*mm;
// handlebar clamp depth (radial)
dc_H = 23*mm;
// handlebar clamp length (tangential)
lc_H = 20*mm; 
// handlebar clamp screw-to-inside offset (tangential)
rc_H = 5.5*mm;
// handlebar clamp gap
gc_H = 3*mm;
// handlebar clamp screw head part length
tc_H = 5*mm;
// handlebar screw head socket depth
ls_H = 1.5*mm;
// handlebar screw head socket diameter
d2_H = 8*mm;
// handlebar screw clearance hole diameter
d1_H = 4.5*mm;
// handlebar screw threadable hole diameter
d0_H = 3.5*mm;

// The design is centered around the handlebar. Handlebar is Z-up.
// Handlebar-horn offset is along X.

// outer diameters
Do_h = D_h + 2*t_h;
Do_H = D_H + 2*t_H;
// horn-handlebar offset
d_hH = t_hH + (D_h + D_H)/2;
// clamp-handlebar axis offset
d_cH = D_H/2 + rc_H;
// handlebar clamp splitter depth (radial)
ds_H = D_H/2 + rc_H + wc_H/2;
// handlebar clamp tangential offset
lco_H = (lc_H-gc_H)/2 - tc_H;
// print height
H = Do_h;
// additional size for subtractions to cut through faces
eps = 1e-3*mm;

// to print without supports, the clamp needs to have a sloping support
// face

// maximum angle due to printer capability (0=vertical)
s_max1 = 55;
// minimum angle to meet the outer surface of the handlebar
s_max_a = rc_H-1.4*t_H; // sqrt(2)? seems like a mistake
s_max_b = D_H/2;
s_max_c2 = s_max_a*s_max_a + s_max_b*s_max_b;
s_max_c = sqrt(s_max_c2);
s_max_r = wc_H/2;
s_max_d = sqrt(s_max_c2 - s_max_r*s_max_r);
s_max2 = atan2(s_max_a, s_max_b) + atan2(s_max_r, s_max_d);
// maximum angle of support (0=vertical)
s_max = min(s_max1, s_max2);
// location of the support tangency point to the cylinder, vs. screw
s_d1 = wc_H/2 * cos(s_max); // out
s_h1 = wc_H/2 * sin(s_max); // down
// location of the support base point, vs tangency point above
s_h2 = H/2 - s_h1;
s_d2 = s_h2 * tan(s_max);
// radius of the sloping support base
s_r = d_cH + s_d1 - s_d2;

module on_hbar() children();
module on_hbar_horn() translate([d_hH/2,0]) children();
module on_horn() translate([d_hH,0]) rotate([90,0,0]) children();
module on_clamp_plane() rotate([90,0,90]) translate([0,0,lco_H]) children();
module on_clamp() translate([0,d_cH]) rotate([0,90,180]) translate([0,0,-lco_H]) children();

// cross-section of the clamp, in global origin YZ plane
module clamp_section() union() {
    polygon(
        [[0, -H/2], [s_r, -H/2], [s_r + s_d2, -H/2 + s_h2],
        [d_cH, wc_H/2], [0, wc_H/2]]
    );
    translate([d_cH,0]) circle(d=wc_H);
}

difference() {
    union() {
        // handlebar shell
        on_hbar() cylinder(d=Do_H, h=H, center=true);
        // handlebar-to-horn block
        on_hbar_horn() cube([d_hH, l_h, H], center=true);
        // horn shell
        on_horn() cylinder(d=Do_h, h=l_h, center=true);
        // clamp block and shell
        on_clamp_plane() linear_extrude(height=lc_H, center=true) clamp_section();
    }
    // handlebar hole
    on_hbar() cylinder(d=D_H, h=H, center=true);
    on_horn() {
        // horn hole
        cylinder(d=D_h, h=l_h+eps, center=true);
        // horn clearance_cone
        translate([0,0,-l_h/2-r_h-eps]) cylinder(d1=Do_h, d2=0, h=Do_h/2);
        rotate([0,-90,0]) {
            // horn setscrew hole
            cylinder(d=d0_h, h=D_h/2 + t_hH + D_H/2);
            // horn setscrew clearance hole
            translate([0,0,D_h/2 + t_hH - c_h])
                cylinder(d=d1_h, h=c_h + D_H + t_H);
        }
    }
    on_clamp() {
        // clamp screw threadable hole
        cylinder(d=d0_H, h=lc_H+eps, center=true);
        // clamp gap
        translate([0, -d_cH+ds_H/2, lco_H])
            cube([H+eps, ds_H, gc_H], center=true);
        // clamp screw head socket
        translate([0, 0, lc_H/2 - ls_H/2 + eps])
            cylinder(d=d2_H, h=ls_H+eps/2, center=true);
        // clamp screw clearance
        translate([0, 0, lc_H/2 - tc_H/2])
            cylinder(d=d1_H, h=tc_H+eps, center=true);
    }
}




