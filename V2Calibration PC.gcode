G21 ; set units to millimeters
G90 ; use absolute coordinates
M107 ; fan off
M104 S290
M140 S115
M190 S115
M109 S290
G87
G88
G28 ; home
G92 E0.0 ; set extruder reference position
G0 Z80 F3000 ; go higher to allow switch lock
G4 ; finish moves
M0 Retract the switch...
G0 Z0
G1 X60.0 E9.0  F1000
G1 X100.0 E12.5  F1000
G92 E0.0
M83 ; use relative distances for extrusion
G1 E-1.50000 F2100
G1 Z0.150 F7200
M204 S1000
G1 F4000
G1 X50 Y155 
G1 F1080
G1 X75 Y155 E2.5
G1 X100 Y155 E2
G1 X200 Y155 E2.62773
G1 X200 Y135 E0.66174
G1 X50 Y135 E3.62773
G1 X50 Y115 E0.49386
G1 X200 Y115 E3.62773
G1 X200 Y95 E0.49386
G1 X50 Y95 E3.62773
G1 X50 Y75 E0.49386
G1 X200 Y75 E3.62773
G1 X200 Y55 E0.49386
G1 X50 Y55 E3.62773
G1 E-0.07500 F2100
G4
M107
M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
G1 X10 Y180 F4000  ; home X axis
G1 Z10 F1300
M84     ; disable motors
