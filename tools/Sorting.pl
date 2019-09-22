#!/usr/bin/perl
#
# Fanboy Adblock Sorter v1.5 (22/03/2011)
#
# Dual License CCby3.0/GPLv2
# http://creativecommons.org/licenses/by/3.0/
# http://www.gnu.org/licenses/gpl-2.0.html
#
# Usage: perl sort.pl <filename.txt>
#
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