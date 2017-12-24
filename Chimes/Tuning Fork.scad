include <MCAD/units.scad>

// * Material Properties *

PLA=0;
ABS=1;
ALU=2;
STEEL_A216=3;

properties=[ // E, rho in SI units
    [3.5E9, 1.3e3],
    [2.0E9, 1.1e3],
    [68E9, 2.790e3],
    [190E9, 7.8e3]
];

function E_of(mat) = properties[mat][0];
function rho_of(mat) = properties[mat][1];

// * Section Properties *

RECT=1;   // [+/-1, [b,h], pos]
CIRCLE=2; // [+/-2, dia, pos]

function bounding_box_1(area) =
    let(type = abs(area[0]))
    let(sig = area[0] > 0 ? 1 : -1)
    let(size = area[1])
    let(pos = area[2])
    let(size2 = size/2)
    sig < 0 ? undef :
    type == RECT ? [pos-size2, pos+size2] :
    type == CIRCLE ? [pos-size2*[1,1], pos+size2*[1,1]] :
    undef;

function bbox_size(bbox) =
    [bbox[1][0] - bbox[0][0], bbox[1][1] - bbox[0][1]];

function area_1(area) =
    let(type = abs(area[0]))
    let(size = area[1])
    type == RECT ? size[0]*size[1] :
    type == CIRCLE ? PI*pow((size/2),2) :
    undef;

function I_1(area) =
    let(type = abs(area[0]))
    let(size = area[1])
    type == RECT ? [size[0]*pow(size[1],3)/12, pow(size[0],3)*size[1]/12] :
    type == CIRCLE ? [PI/4*pow(size/2,4), PI/4*pow(size/2,4)] :
    undef;

function centroid(areas, i=0, sp=[0,0], sA=0) =
    i >= len(areas) ? sp/sA :
    let(area = areas[i])
    let(pos = area[2])
    let(A = area_1(area))
    centroid(areas, i+1, sp+A*pos, sA+A);

function I(areas, i=0, I_=[0,0], C_) =
    i >= len(areas) ? I_ :
    let(C = i==0 ? centroid(areas) : C_)
    let(area = areas[i])
    let(type = abs(area[0]))
    let(sig = area[0]>0 ? 1 : -1)
    let(size = area[1])
    let(A = area_1(area))
    let(pos = area[2] - C) // centroid-relative
    let(Ioffs = [A*pos[1]*pos[1], A*pos[0]*pos[0]])
    I(areas, i+1, I_ + sig*(I_1([area[0], size]) + Ioffs), C);

function bounding_box(areas, i=0, last=undef) =
    // bounding box of positive areas; negative areas are ignored
    i >= len(areas) ? last :
    let(area = areas[i])
    let(this = bounding_box_1(area))
    let(both = [[min(last[0][0],last[1][0],this[0][0],this[1][0]),
                 min(last[0][1],last[1][1],this[0][1],this[1][1])],
                [max(last[0][0],last[1][0],this[0][0],this[1][0]),
                 max(last[0][1],last[1][1],this[0][1],this[1][1])]])
    let(new = last==undef ? this : this==undef ? last : both)
    bounding_box(areas, i+1, new);

function area(areas, i=0, area_=0) =
    let(sig = areas[i][0] > 0 ? 1 : -1)
    i >= len(areas) ? area_ :
    area(areas, i+1, area_ + sig*area_1(areas[i]));

// * Section Generator *

module section_1(area) {
    type = abs(area[0]);
    size = area[1];
    pos = area[2];
         if (type == RECT) translate(pos) square(size=size, center=true);
    else if (type == CIRCLE) translate(pos) circle(d=size);
}

// center-centered on the centroid
module section(areas, center=false)
    translate(center ? -centroid(area) : -bounding_box(areas)[0])
    difference() {
        union() for(a = areas) if (a[0]>0) section_1(a);
        union() for(a = areas) if (a[0]<0) section_1(a);
    }

// * Natural Frequencies *

function fork_freq(l, Ix, A, E, rho) =
    pow(1.875,2)/(2*PI*pow(l,2))*sqrt(E*Ix/(rho*A));

function fork_freq_mat(l, Ix, A, mat=PLA) =
    fork_freq(l, Ix, A, E_of(mat), rho_of(mat));

function fork_freq_m(l, Ix, A, E, rho, m) =
    let(m_b = 0.2235*l*A*rho + m)
    1/(2*PI)*sqrt(3*E*Ix/(m_b*pow(l,3)));

function fork_freq_m_mat(l, Ix, A, m, mat=PLA) =
    fork_freq_m(l, Ix, A, E_of(mat), rho_of(mat), m);

// * Pitches *

MIDI_C4 = 60;
function pitch(midi) = pow(2,((midi-69)/12))*440; // Hz, A4=440

// ----------------------------

// Test for a steel fork of known dimensions
in = 0.0254;

f_C5_ref = pitch(MIDI_C4+12);
function f_test_fork() =
    let(l = 3.3*in)
    let(C5 = [[RECT, [0.17*in, 0.18*in], [0,0]]])
    let(I_C5 = I(C5))
    let(A = area(C5))
    fork_freq_mat(l, I_C5[0], A, STEEL_A216);
assert(abs(f_test_fork() - f_C5_ref)<10);

// C4 fork

f_ref = pitch(MIDI_C4);

mat = PLA;
l = 0.075;
t = 0.003;
size = [0.020, 0.010];
C4 = [[RECT, size, [0,0]],
      [-RECT, size-[2*t, t], [0,-t/2]]];

I = I(C4);
A = area(C4);

l_end = 0.031;
m_end = (A*2)*l_end*rho_of(mat);
echo(m_end=m_end/0.001,"g");

f = fork_freq_m_mat(l, I[0], A, m_end, mat);

echo(A=A);
echo(C=centroid(C4));
echo(I=I);
echo(f=f, f_ref=f_ref);
// the fork is sharp - flattening is done by slimming
// down the tines

// ----------------------------


// A tuning fork that can be assembled from three interlocking pieces:
// two identical tines and an adapter.

eps = 0.001*mm;

module fork(part=0) {
    space = 5*mm;
    adapter = 30*mm;
    handle = 40*mm;
    t = 3*mm; // thicknes of walls around the lock
    h = 4*mm; // height of the lock

    bbox = bounding_box(C4);
    size = bbox_size(bbox);
    width = 1000*size[0];

    lock=[adapter-t*2, width-t*2];

    if (part == 0) difference() {
        scale(1000) translate([0, -size[0]/2]) rotate([90,0,90]) {
            linear_extrude(height = l) section(C4);
            translate([0,0,l-l_end/2]) linear_extrude(height=l_end)
                square(size=[size[0], size[1]*2]);
            translate([0,0,-adapter/1000]) linear_extrude(height=adapter/1000)
                square(size=size);
        }
        translate([-adapter/2, 0, -eps]) linear_extrude(height=h)
            square(size=lock, center=true);
    }
    if (part == 1 || part == 2) {
        space = part == 1 ? space : space*2;
        linear_extrude(height=2*h+space) square(size=lock, center=true);
    }
    if (part == 3) {
        linear_extrude(height=h) square(size=lock, center=true);
        translate([0,0,h]) linear_extrude(height=space) square(size=[adapter, width], center=true);
        translate([0,0,h+space]) linear_extrude(height=h) square(size=lock, center=true);
    }
}

fork(0);
