// Cube gears 3 - pinned, no vitamins needed

use <MCAD/involute_gears.scad>

//center();
//gear1();
//gear2();
//gear3();
//gear4();
//gear5();
//gear6();
//gear7();
//gear8();
//rotate(a=[0,theta-90,0])center();
//twogears();// render sub-assembly
//eightgears();// render full assembly
plate(plate_all); // render the build plate
//%baseshape();// render original shape (transparent, OpenCSG only)

cs=75;// cube size (side length)
rf1=2*cs;// distance from center of cube to cut corner faces
cp=1/10;// percentage of rf1 for the center block
td=0;// tapping diameter
cd=0;// clearance hole diameter
hd=0;// screw head clearance diameter
Ls=20;// length of screw
ps=10;// penetration of screw into center block
$fs=td/6;// adjust number of faces in holes

n1=18;// number of teeth on gear1
n2=9;// number of teeth on gear2
// Run gearopt.m with inputs of n1 and n2 above, copy outputs r1 and r2 below.
r1=0.7493;
r2=0.3746;

plate_all = 0;
plate_gears = 1;
plate_pins = 2;
module plate(what = plate_all) {
    if (what == plate_all || what == plate_gears) {
        translate([0,15,0]) gear1(flat=1);
        translate([55,23,0]) gear2(flat=1);
        translate([44,-23,0]) gear4(flat=1);
        translate([115,0,0]) gear3(flat=1);
        translate([0,-72,0]) gear5(flat=1);
        translate([68,-64,0]) gear6(flat=1);
        translate([122,-87,0]) gear7(flat=1);
        translate([62,-102,0]) rotate([0,0,180/n2]) gear8(flat=1);
        translate([0,-130,cp*rf1]) rotate(a=[-90-theta,0,0]) center();
    }
    if (what == plate_all || what == plate_pins)
        translate(what == plate_all ? [30, -130, 0] : 0)
            for(j=[0:7]) translate([j*10,0,0]) render() pinpeg();
}

module baseshape() {
	translate([6, 0, -4]) sphere(cs / 2 * 1.4, center=true);
}

// -------------- Don't edit below here unless you know what you're doing.
dc=rf1/sqrt(1-pow(r1,2));
theta=asin(1/sqrt(3));
pitch=360*r1*dc/n1;
rf2=sqrt(pow(dc,2)-pow(r2*dc,2));
phi1=90/n1 * 0;
phi2=90/n2 * 0 + 60;

module twogears(){
	center();
	rotate(a=[0,90-theta,0])gear2();
	rotate(a=[0,90-theta,90])gear1();
}

module eightgears() rotate([0, 0, 45]) {
	center();
	color([0.5, 0.5, 0.5]) rotate(a=[0,90-theta,90]) rotate([0, 0, 360 * $t]) gear1();
	color([0.5, 0.5, 0.5]) rotate(a=[0,90-theta,0]) rotate([0, 0, -720 * $t]) gear2();
	color([1, 0, 0]) rotate(a=[0,90+theta,0]) rotate([0, 0, 360 * $t])gear3();
	color([1, 0, 0]) rotate(a=[0,90+theta,90]) rotate([0, 0, -720 * $t]) gear4();
	color([0, 1, 0]) rotate(a=[0,90+theta,180]) rotate([0, 0, 360 * $t])gear5();
	color([0, 1, 0]) rotate(a=[0,90+theta,-90]) rotate([0, 0, -720 * $t]) gear6();
	color([0, 0, 1]) rotate(a=[0,90-theta,-90]) rotate([0, 0, 360 * $t])gear7();
	color([0, 0, 1]) rotate(a=[0,90-theta,180]) rotate([0, 0, -720 * $t]) gear8();
}

H1 = bevel_gear_flat_height(number_of_teeth=n1,
     outside_circular_pitch=pitch,
     cone_distance=dc,
     face_width=dc*(1-cp));

H2 = bevel_gear_flat_height(number_of_teeth=n2,
     outside_circular_pitch=pitch,
     cone_distance=dc,
     face_width=dc*(1-cp));

module gear1(flat=0) translate([0,0,-(rf1-H1)*flat]) render()
    biggear() rotate([0, 0, 180]) baseshape();
module gear2() translate([0,0,-(rf2-H2)*flat]) render()
    smallgear() rotate([0, 0, -90]) baseshape();
module gear3() render() translate([0,0,-(rf1-H1)*flat])
    rotate([0, 0, 180]) biggear() rotate([0, 180, 180]) baseshape();
module gear4() render() translate([0,0,-(rf2-H2)*flat])
    rotate([0, 0, 180]) smallgear() rotate([0, 180, -90]) baseshape();
module gear5() render() translate([0,0,-(rf1-H1)*flat])
    rotate([0, 0, 180]) biggear() rotate([0, 180, 0]) baseshape();
module gear6() render() translate([0,0,-(rf2-H2)*flat])
    rotate([0, 0, 180]) smallgear() rotate([0, 180, 90]) baseshape();
module gear7() render() translate([0,0,-(rf1-H1)*flat])
    biggear() rotate([0, 0, 0]) baseshape();
module gear8() render() translate([0,0,-(rf2-H2)*flat])
    smallgear() rotate([0, 0, 90]) baseshape();

module center() render() {
intersection(){
	rotate(a=[-90-theta,0,0])box();
	rotate(a=[-90-theta,0,180])box();
	rotate(a=[90-theta,0,90])box();
	rotate(a=[90-theta,0,-90])box();
}}

module box(){
    h = (rf1+rf2)*cp;
    translate([0,0,(rf2-rf1)*cp/2]) difference(){
        cube(size=[dc,dc,h],center=true);
        translate([0,0,-h/2])
            pinhole(fixed=true, fins=false);
        translate([0,0,h/2]) rotate([180,0,0])
            pinhole(fixed=true, fins=false);
    }
}

module biggear(){
intersection(){
	rotate(a=[0,theta-90,0])rotate([0,0,45])children(0);
	rotate(a=[180,0,phi1])translate([0,0,-rf1])
	render() difference(){
		bevel_gear (number_of_teeth=n1,
			outside_circular_pitch=pitch,
			cone_distance=dc,
			face_width=dc*(1-cp),
			bore_diameter=cd,
			finish=0);
		translate([0,0,H1]) rotate([180,0,0]) pinhole(fins=false);
	}
}}

module smallgear(){
intersection(){
	rotate(a=[0,theta-90,0])rotate([0,0,45])children(0);
	cube(size=2*rf1, center=true);
	rotate(a=[180,0,phi2])translate([0,0,-rf2])
	render() difference(){
		bevel_gear (number_of_teeth=n2,
			outside_circular_pitch=pitch,
			cone_distance=dc,
			face_width=dc*(1-cp),
			bore_diameter=cd);
        translate([0,0,H2]) rotate([180,0,0]) pinhole(fins=false);
	}
}}

function bevel_gear_flat_height(
    number_of_teeth=11,
	cone_distance=100,
    face_width=20,
	outside_circular_pitch=1000)
=
    let(outside_pitch_diameter = number_of_teeth * outside_circular_pitch / 180)
	let(outside_pitch_radius = outside_pitch_diameter / 2)
    let(pitch_angle = asin (outside_pitch_radius/cone_distance))
    let(pitch_apex = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius, 2)))
    pitch_apex - (cone_distance - face_width) * cos (pitch_angle);

// Parametric Snap Pins (http://www.thingiverse.com/thing:213310)

module pin(r=3.5,l=13,d=2.4,slot=10,nub=0.4,t=1.8,space=0.3,flat=1)
translate(flat*[0,0,r/sqrt(2)-space])rotate((1-flat)*[90,0,0])
difference(){
	rotate([-90,0,0])intersection(){
		union(){
			translate([0,0,-0.01])cylinder(r=r-space,h=l-r-0.98);
			translate([0,0,l-r-1])cylinder(r1=r-space,r2=0,h=r-space/2+1);
			translate([nub+space,0,d])nub(r-space,nub+space);
			translate([-nub-space,0,d])nub(r-space,nub+space);
		}
		cube([3*r,r*sqrt(2)-2*space,2*l+3*r],center=true);
	}
	translate([0,d,0])cube([2*(r-t-space),slot,2*r],center=true);
	translate([0,d-slot/2,0])cylinder(r=r-t-space,h=2*r,center=true,$fn=12);
	translate([0,d+slot/2,0])cylinder(r=r-t-space,h=2*r,center=true,$fn=12);
}

module nub(r,nub)
union(){
	translate([0,0,-nub-0.5])cylinder(r1=r-nub,r2=r,h=nub);
	cylinder(r=r,h=1.02,center=true);
	translate([0,0,0.5])cylinder(r1=r,r2=r-nub,h=5);
}

module pinhole(r=3.5,l=13,d=2.5,nub=0.4,fixed=false,fins=true)
intersection(){
	union(){
		translate([0,0,-0.1])cylinder(r=r,h=l-r+0.1);
		translate([0,0,l-r-0.01])cylinder(r1=r,r2=0,h=r);
		translate([0,0,d])nub(r+nub,nub);
		if(fins)translate([0,0,l-r]){
			cube([2*r,0.01,2*r],center=true);
			cube([0.01,2*r,2*r],center=true);
		}
	}
	if(fixed)cube([3*r,r*sqrt(2),2*l+3*r],center=true);
}

module pinpeg(r=3.5,l=13,d=2.4,nub=0.4,t=1.8,space=0.3, flat=1)
union(){
	pin(r=r,l=l,d=d,nub=nub,t=t,space=space,flat=flat);
	mirror([0,flat,1-flat])pin(r=r,l=l,d=d,nub=nub,t=t,space=space,flat=flat);
}
