#!/usr/bin/perl

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
## Title: updateDateString.pl
## URL: https://raw.githubusercontent.com/bogachenko/presstheattack/master/tools/updateDateString.pl
## Wiki: https://github.com/bogachenko/presstheattack/wiki
##
## Download the entire Press the Attack project at https://github.com/bogachenko/presstheattack/archive/master.zip

use strict;
use warnings;
use Time::Piece qw(localtime);
die "Usage: $^X $0 subscription.txt\n" unless @ARGV;
my $file = $ARGV[0];
my $data = readFile($file);
my $time    = localtime();
my $strDateTime = $time->strftime("%F, %X");
my $strVersion = $time->strftime("%Y%m%d%H%M%S");
die "[ERR] Failed to Generate DateTime String!" unless $strDateTime;
die "[ERR] Failed to Generate Version String!"  unless $strVersion;
$data =~ s/^.*!\s*Last\s+modified[\s\-:]+([\w\+\/=]+).*$/! Last modified: $strDateTime/gmi;
$data =~ s/^.*!\s*Version[\s\-:]+([\w\+\/=]+).*$/! Version: $strVersion/gmi;
writeFile($file, $data);
sub readFile
{
  my $file = shift;
  open(local *FILE, "<", $file) || die "Could not read file '$file'";
  binmode(FILE);
  local $/;
  my $result = <FILE>;
  close(FILE);
  return $result;
}
sub writeFile
{
  my ($file, $contents) = @_;
  open(local *FILE, ">", $file) || die "Could not write file '$file'";
  binmode(FILE);
  print FILE $contents;
  close(FILE);
}