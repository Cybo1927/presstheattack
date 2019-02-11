#!/usr/bin/perl

## ALL RIGHTS TO THIS SCRIPT BELONG TO HIS CREATOR
## The authorship of the script belongs to Fanboynz <https://github.com/ryanbr>
## The script is borrowed from here https://github.com/ryanbr/fanboy-adblock

## This file is part of the Press the Attack project,
## Copyright (c) 2019 Bogachenko Vyacheslav
##
## Press the Attack is a free project: you can distribute it and/or modify
## it in accordance with the MIT license published by the Massachusetts Institute of Technology.
##
## The Press the Attack project is distributed in the hope that it will be useful,
## and is provided "AS IS", WITHOUT ANY WARRANTY, EXPRESSLY EXPRESSED OR IMPLIED.
## WE ARE NOT RESPONSIBLE FOR ANY DAMAGES DUE TO THE USE OF THIS PROJECT OR ITS PARTS.
## For more information, see the MIT license.
##
## Github: https://github.com/bogachenko/presstheattack/
## Last modified: February 11, 2019
## License: MIT <https://github.com/bogachenko/presstheattack/blob/master/LICENSE.md>
## Problem reports: https://github.com/bogachenko/presstheattack/issues
## Title: validateChecksum.pl
## URL: https://raw.githubusercontent.com/bogachenko/presstheattack/master/tools/validateChecksum.pl
## Wiki: https://github.com/bogachenko/presstheattack/wiki
##
## Download the entire Press the Attack project at https://github.com/bogachenko/presstheattack/archive/master.zip

use strict;
use warnings;
use File::Copy;
sub output {
    my( $lines, $fh ) = @_;
    return unless @$lines;
    print $fh shift @$lines;
    print $fh sort { lc $a cmp lc $b } @$lines;
    return;
}
foreach my $filename (@ARGV) {
    my $outfn = "$filename.out";
    open my $fh, '<', $filename or die "open $filename: $!";
    open my $fhout, '>', $outfn or die "open $outfn: $!";
    my $filetobecopied = $outfn;
    my $newfile = $filename;
    binmode($fhout);
    my $current = [];
    while ( <$fh> ) {
        if ( m/^(?:[!\[]|[#|;]\s)/ ) {
            output $current, $fhout;
            $current = [ $_ ];
        }
        else {
            push @$current, $_;
        }
    }
    output $current, $fhout;
    close $fhout;
    close $fh;
    move($filetobecopied, $newfile);

}