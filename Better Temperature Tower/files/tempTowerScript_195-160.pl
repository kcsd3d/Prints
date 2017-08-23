#!/usr/bin/perl -i                                                     
use strict;
use warnings;
$^I = '.bak';
while (<>) {
     # modify $_ here before printing
	if (/^; Layer 45/) {
	  print;
	  print "M104 S195\n";
	}elsif (/^; Layer 80/) {
	  print;
	  print "M104 S190\n";
	}elsif (/^; Layer 116/) {
	  print;
	  print "M104 S185\n";
	}elsif (/^; Layer 151/) {
	  print;
	  print "M104 S180\n";
	}elsif (/^; Layer 186/) {
	  print;
	  print "M104 S175\n";
	}elsif (/^; Layer 221/) {
	  print;
	  print "M104 S170\n";
	}elsif (/^; Layer 256/) {
	  print;
	  print "M104 S165\n";
	}elsif (/^; Layer 291/) {
	  print;
	  print "M104 S160\n";
	}else {print;}
}

#<setpoint layer="45" temperature="195"/>
#<setpoint layer="80" temperature="190"/>
#<setpoint layer="116" temperature="185"/>
#<setpoint layer="151" temperature="180"/>
#<setpoint layer="186" temperature="175"/>
#<setpoint layer="221" temperature="170"/>
#<setpoint layer="256" temperature="165"/>
#<setpoint layer="291" temperature="160"/>
# ; layer 45