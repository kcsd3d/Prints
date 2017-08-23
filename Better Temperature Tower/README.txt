                   .:                     :,                                          
,:::::::: ::`      :::                   :::                                          
,:::::::: ::`      :::                   :::                                          
.,,:::,,, ::`.:,   ... .. .:,     .:. ..`... ..`   ..   .:,    .. ::  .::,     .:,`   
   ,::    :::::::  ::, :::::::  `:::::::.,:: :::  ::: .::::::  ::::: ::::::  .::::::  
   ,::    :::::::: ::, :::::::: ::::::::.,:: :::  ::: :::,:::, ::::: ::::::, :::::::: 
   ,::    :::  ::: ::, :::  :::`::.  :::.,::  ::,`::`:::   ::: :::  `::,`   :::   ::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  :::::: ::::::::: ::`   :::::: ::::::::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  .::::: ::::::::: ::`    ::::::::::::::: 
   ,::    ::.  ::: ::, ::`  ::: ::: `:::.,::   ::::  :::`  ,,, ::`  .::  :::.::.  ,,, 
   ,::    ::.  ::: ::, ::`  ::: ::::::::.,::   ::::   :::::::` ::`   ::::::: :::::::. 
   ,::    ::.  ::: ::, ::`  :::  :::::::`,::    ::.    :::::`  ::`   ::::::   :::::.  
                                ::,  ,::                               ``             
                                ::::::::                                              
                                 ::::::                                               
                                  `,,`


http://www.thingiverse.com/thing:2184626
Better temperature tower 240-160 and 200-160 by Thump2010 is licensed under the Creative Commons - Attribution - Non-Commercial license.
http://creativecommons.org/licenses/by-nc/3.0/

# Summary

No two filaments are alike and no two give their best at the same temp so I made this temperature tower to test filament temperatures, it goes down to 160 as I have had some cheap chinese filaments run like water at 190 and print at 160.
I am including 2 towers a 240-160 version and a 200-160 version.

This temperature tower has square edges, lettering, 40 degree angle, 60 degree angle, and bridges

I print it (stop it if it quits early) then give it a good look and see at what temperature all the above printed the best at, then I start snapping off pieces with my hands to see what temp gives me the best layer adhesion and then mark the spool with that temperature.

I use simplify3d, if you use that export your profile find the temperature section and copy and paste the "layer temperature settings" that are below into it, rename the profile if you want, save and import, that's it, it is really that easy with S3d

With Cura you can do the same thing but you have to use "tweak at layer height" plugin, set the layer height to match the list and then the temperature, you can save the profile once set so that you don't have to do it again.
if you are using something else like slic3r you cannot set individual layer heights like you can in simplify3d and Cura, Check my 4/21/2017 update for instructions for Slic3r.

If using Simplify3d set the Unsupported area threshold under the other tab to 25 or below instead of 50, 50 is a bit high for short bridges.

<b>Update 3/17/2017</b>
Moved the bridges down to be in their proper temperature ranges.
Uploaded v5 of the STLs

<b>Update 4/22/2017</b>
I wrote a couple scripts for Slic3r since it limits things that you can do.
There are two scripts, one for each tower, you would put the one in that you are going to use.
To make the scripts work you have to add a gcode line then put the script in place.
<b>You MUST install some sort of PERL and have it in your windows path, I use active perl.
You MUST put Slic3r into expert mode to get to all the places in the instructions.
If you have issues with Slic3r then please reach out to the Slic3r community.</b>
Instructions for Slic3r:
1. Save the scripts to your hard drive.
2. Open Slic3r and go to <b>Settings -> Print Settings</b> 
3. Select "<b>Output options</b>" on the left hand window.
4. in the "<b>Post-processing scripts</b>" box add the full path and name of the script you are going to use.
i.e. I saved my script to my F drive under 3d so I would put F:\3D\tempTowerScript_235-160.pl
5. Close the window
6. Go to <b>Settings -> Printer Settings</b>
7. Select "<b>Custom G-code</b>" on the left.
8. Scroll down until you find the box for "<b>Before layer change G-code</b>".
9. put in the box "<b>; Layer [layer_num]</b>" without the quotes, it must be identical to that including capitalization.
10. Close window, then slice the model.

You can open the gcode file and search for <b>; Layer 45</b> and if everything works there will be a <b>M104</b> line under it.
I have included some screenshots also

# Print Settings

Printer: Rob-O Junior
Rafts: Doesn't Matter
Supports: No
Resolution: 0.2

Notes: 
240-160 layer temperature settings.
    <setpoint layer="1" temperature="240"/>
    <setpoint layer="45" temperature="235"/>
    <setpoint layer="80" temperature="230"/>
    <setpoint layer="116" temperature="225"/>
    <setpoint layer="151" temperature="220"/>
    <setpoint layer="186" temperature="215"/>
    <setpoint layer="221" temperature="210"/>
    <setpoint layer="256" temperature="205"/>
    <setpoint layer="291" temperature="200"/>
    <setpoint layer="326" temperature="195"/>
    <setpoint layer="361" temperature="190"/>
    <setpoint layer="396" temperature="185"/>
    <setpoint layer="431" temperature="180"/>
    <setpoint layer="466" temperature="175"/>
    <setpoint layer="501" temperature="170"/>
    <setpoint layer="536" temperature="165"/>
    <setpoint layer="571" temperature="160"/>

200-160 layer temperature settings.
    <setpoint layer="1" temperature="200"/>
    <setpoint layer="45" temperature="195"/>
    <setpoint layer="80" temperature="190"/>
    <setpoint layer="116" temperature="185"/>
    <setpoint layer="151" temperature="180"/>
    <setpoint layer="186" temperature="175"/>
    <setpoint layer="221" temperature="170"/>
    <setpoint layer="256" temperature="165"/>
    <setpoint layer="291" temperature="160"/>