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
## Title: validateChecksum.pl
## URL: https://raw.githubusercontent.com/bogachenko/presstheattack/master/tools/validateChecksum.pl
## Wiki: https://github.com/bogachenko/presstheattack/wiki
##
## Download the entire Press the Attack project at https://github.com/bogachenko/presstheattack/archive/master.zip

use strict;
use warnings;
use Digest::MD5 qw(md5_base64);
die "Usage: $^X $0 subscription.txt\n" unless @ARGV;
my $file = $ARGV[0];
my $data = readFile($file);
$data =~ s/\r//g;
$data =~ s/\n+/\n/g;
$data =~ s/^\s*!\s*checksum[\s\-:]+([\w\+\/=]+).*\n//mi;
my $checksum = $1;
die "Couldn't find a checksum in the file\n" unless $checksum;
my $checksumExpected = md5_base64($data);
if ($checksum eq $checksumExpected)
{
  print "[OK] Checksum is valid.\n";
  exit(0);
}
else
{
  print "[Wrong checksum] found $checksum, expected [$checksumExpected].\n";
  exit(1);
}
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