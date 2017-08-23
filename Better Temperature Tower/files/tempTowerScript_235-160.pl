#!/usr/bin/perl -i                                                     
use strict;
use warnings;
$^I = '.bak';
my $suppress = 0;
print ";Processed by $0\n";
while (<>) {
    # modify $_ here before printing
	if (/^M104 /) {
		print "M104 S240\n";
	}elsif (/^M109 /) {
		print "M109 S240\n";
	}elsif (/^; Layer 45$/) {
	  print;
	  print "M104 S235\n";
	}elsif (/^; Layer 80$/) {
	  print;
	  print "M104 S230\n";
	}elsif (/^; Layer 116$/) {
	  print;
	  print "M104 S225\n";
	}elsif (/^; Layer 151$/) {
	  print;
	  print "M104 S220\n";
	}elsif (/^; Layer 186$/) {
	  print;
	  print "M104 S215\n";
	}elsif (/^; Layer 221$/) {
	  print;
	  print "M104 S210\n";
	}elsif (/^; Layer 256$/) {
	  print;
	  print "M104 S205\n";
	}elsif (/^; Layer 291$/) {
	  print;
	  print "M104 S200\n";
	}elsif (/^; Layer 326$/) {
	  print;
	  print "M104 S195\n";
	}elsif (/^; Layer 361$/) {
	  print;
	  print "M104 S190\n";
	}elsif (/^; Layer 396$/) {
	  print;
	  print "M104 S185\n";
	}elsif (/^; Layer 431$/) {
	  print;
	  print "M104 S180\n";
	}elsif (/^; Layer 466$/) {
	  print;
	  print "M104 S175\n";
	  $suppress = 1;
	}elsif (/^; Layer 501$/) {
	  print;
	  print "M104 S170\n";
	}elsif (/^; Layer 536$/) {
	  print;
	  print "M104 S165\n";
	}elsif (/^; Layer 571$/) {
	  print;
	  print "M104 S160\n";
	}elsif (/^;END gcode for filament/) {
	  print;
	  $suppress = 0;
	}elsif (! $suppress) {
	  print;
	}
}

#<setpoint layer="45" temperature="235"/>
#<setpoint layer="80" temperature="230"/>
#<setpoint layer="116" temperature="225"/>
#<setpoint layer="151" temperature="220"/>
#<setpoint layer="186" temperature="215"/>
#<setpoint layer="221" temperature="210"/>
#<setpoint layer="256" temperature="205"/>
#<setpoint layer="291" temperature="200"/>
#<setpoint layer="326" temperature="195"/>
#<setpoint layer="361" temperature="190"/>
#<setpoint layer="396" temperature="185"/>
#<setpoint layer="431" temperature="180"/>
#<setpoint layer="466" temperature="175"/>
#<setpoint layer="501" temperature="170"/>
#<setpoint layer="536" temperature="165"/>
#<setpoint layer="571" temperature="160"/>
# ; layer 45