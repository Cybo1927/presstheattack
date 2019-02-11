#!/usr/bin/perl

## ALL RIGHTS TO THIS SCRIPT BELONG TO HIS CREATOR
## The authorship of the script belongs to k2jp <https://github.com/k2jp>
## The script is borrowed from here https://github.com/k2jp/abp-japanese-filters

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
## Title: addChecksum.pl
## URL: https://raw.githubusercontent.com/bogachenko/presstheattack/master/tools/addChecksum.pl
## Wiki: https://github.com/bogachenko/presstheattack/wiki
##
## Download the entire Press the Attack project at https://github.com/bogachenko/presstheattack/archive/master.zip

use strict;
use warnings;
use Digest::MD5 qw(md5_base64);
die "Usage: $^X $0 subscription.txt\n" unless @ARGV;
my $file = $ARGV[0];
my $data = readFile($file);
$data =~ s/^.*!\s*checksum[\s\-:]+([\w\+\/=]+).*\n//gmi;
my $checksumData = $data;
$checksumData =~ s/\r//g;
$checksumData =~ s/\n+/\n/g;
my $checksum = md5_base64($checksumData);
$data =~ s/(\r?\n)/$1! Checksum: $checksum$1/;
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