include <MCAD/units.scad>

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

RECT=1;   // [+/-1, [b,h], pos]
CIRCLE=2; // [+/-2, dia, pos]

function area_1(area) =
    let(type = abs(area[0]))
    let(size = area[1])
    type == RECT ? size[0]*size[1] :
    type == CIRCLE ? PI*pow((size/2),2) :
    undef;

function I_1(area) =
    let(type = abs(area[0]))
    let(sig = type > 0 ? 1 : -1)
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

function area(areas, i=0, area_=0) =
    let(sig = areas[i][0] > 0 ? 1 : -1)
    i >= len(areas) ? area_ :
    area(areas, i+1, area_ + sig*area_1(areas[i]));

function fork_freq(l, Ix, A, E, rho) =
    pow(1.875,2)/(2*PI*pow(l,2))*sqrt(E*Ix/(rho*A));

function fork_freq_mat(l, Ix, A, mat=PLA) =
    let(props = properties[mat])
    fork_freq(l, Ix, A, props[0], props[1]);

// ----------------------------

f_C4_set = 261.6; // Hz

l_C4 = 0.075;
C4 = [[RECT, [0.007, 0.006], [0,0]]];

I_C4 = I(C4);
A_C4 = area(C4);
f_C4 = fork_freq_mat(l_C4, I_C4[0], A_C4, PLA);

echo(A=A_C4);
echo(C=centroid(C4));
echo(I=I_C4);
echo(f=f_C4);
// the fork is sharp - flattening is done by slimming
// down the tines

// Test for a steel fork of known dimensions
in = 0.0254;
f_C5_set = 523.3;
l_C5 = 3.3*in;
C5 = [[RECT, [0.17*in, 0.18*in], [0,0]]];
I_C5 = I(C5);
A_C5 = area(C5);
f_C5 = fork_freq_mat(l_C5, I_C5[0], A_C5, STEEL_A216);
assert(abs(f_C5 - f_C5_set)<10);

// ----------------------------

space = 10*mm;
l = l_C4*1000;
xs = C4[0][1]*1000;

translate([0, space/2, 0]) cube([l, xs[1], xs[0]]);
translate([0, -space/2-xs[1], 0]) cube([l, xs[1], xs[0]]);
translate([-5, 0, xs[0]/2]) cube([10,space+2*xs[1],xs[0]], center=true);
translate([-5, 0, xs[0]/2]) rotate([0,-90,0]) cylinder(d=xs[0], h=40, $sn=5);