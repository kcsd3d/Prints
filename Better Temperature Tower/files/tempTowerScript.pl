#!/usr/bin/perl -i                                                     

# This script extracts settings from the gcode comments shown below.
# The gcode comments should be added to the filament settings start G-Code in Slic3r
# ; Tower temp 280      - set initial temp to 280 (default: print layer temperature)
# ; Tower temp_step -5  - step temperature down 5 degrees for each block
# ; Tower skip 10       - first block is 10 layers higher than others
# ; Tower block 35      - the blocks are 35 layers high
# ; Tower blocks 10     - (optional) emit only 10 blocks

# Each layer should begin with
# ; Layer [layer_num]   - where [layer_num] is replaced by the layer number

use strict;
use warnings;
$^I = '.bak';

my $s_temp = 280;
my $s_temp_step = -5;
my $s_skip = 10;
my $s_block = 35;
my $s_blocks = 0;

my $hello = 0;
my $temp = $s_temp;
my $layer = 0;
my $block = 0;
my $suppress = 0;

while (<>) {
	if (! $hello) {
		print "; Processed by $0\n";
		$hello = 1;
	}

	my $new_layer = 0;
	
	if (/^; Tower temp ([0-9]+)/) {
		$s_temp = $1;
		$temp = $1;
	} elsif (/^; Tower temp_step ([-0-9]+)/) {
		$s_temp_step = $1;
	} elsif (/^; Tower skip ([0-9]+)/) {
		$s_skip = $1;
	} elsif (/^; Tower block ([0-9]+)/) {
		$s_block = $1;
	} elsif (/^; Tower blocks ([0-9]+)/) {
		$s_blocks = $1;
	} elsif (/^; Layer ([0-9]+)/) {
		$layer = $1;
		$new_layer = 1;
	} elsif (/^M104 S([0-9]+)/ && $block == 0) {
		$s_temp = $1;
		$temp = $1;
	} elsif (/^;END gcode for filament/) {
		$suppress = 0;
	}
	
	if ($new_layer && $layer >= $s_skip && (($layer - $s_skip) % $s_block) == 0) {
		$_ = $_ . "M104 S$temp\n";
		if ($block == 0) { $_ = $_ . "M109 S$temp\n"; } # Wait for temperature
		$block ++;
		$temp += $s_temp_step;
	}
	
	print unless $suppress;
	
	if ($s_blocks && $block > $s_blocks) { $suppress = 1; }
}
