#!/usr/bin/perl -i                                                     
use strict;
use warnings;
$^I = '.bak';
my $suppress = 0;
print ";Processed by $0\n";
if (0) {
	while (<>) {
		print;
	}
	exit
}
while (<>) {
    # modify $_ here before printing
	if (/^M104 .*; set/) {
		print "M104 S280\n";
	}elsif (/^M109 /) {
		print "M109 S280\n";
	}elsif (/^; Layer 45$/) {
	  print;
	  print "M104 S275\n";
	}elsif (/^; Layer 80$/) {
	  print;
	  print "M104 S270\n";
	}elsif (/^; Layer 116$/) {
	  print;
	  print "M104 S265\n";
	}elsif (/^; Layer 151$/) {
	  print;
	  print "M104 S260\n";
	}elsif (/^; Layer 186$/) {
	  print;
	  print "M104 S255\n";
	}elsif (/^; Layer 221$/) {
	  print;
	  print "M104 S250\n";
	}elsif (/^; Layer 256$/) {
	  print;
	  print "M104 S245\n";
	}elsif (/^; Layer 291$/) {
	  print;
	  print "M104 S240\n";
	}elsif (/^; Layer 326$/) {
	  print;
	  print "M104 S235\n";
	}elsif (/^; Layer 361$/) {
	  print;
	  print "M104 S230\n";
	}elsif (/^; Layer 396$/) {
	  print;
	  print "M104 S225\n";
	}elsif (/^; Layer 431$/) {
	  print;
	  print "M104 S220\n";
	}elsif (/^; Layer 466$/) {
	  print;
	  print "M104 S215\n";
	}elsif (/^; Layer 501$/) {
	  print;
	  print "M104 S210\n";
	}elsif (/^; Layer 536$/) {
	  print;
	  print "M104 S205\n";
	  $suppress = 1;
	}elsif (/^; Layer 571$/) {
	  print;
	  print "M104 S200\n";
	}elsif (/^;END gcode for filament/) {
	  print;
	  $suppress = 0;
	}elsif (! $suppress) {
	  print;
	}
}
