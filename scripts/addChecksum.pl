#!/usr/bin/perl

# Copyright 2011 Wladimir Palant
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use Digest::MD5 qw(md5_base64);
die "Usage: $^X $0 subscription.txt\n" unless @ARGV;
foreach my $file (@ARGV) {
  my $data = readFile($file);
  $data =~ /^.*!\s*checksum[\s\-:]+([\w\+\/=]+).*\n/gmi;
  my $oldchecksum = $1;
  $data =~ s/^.*!\s*checksum[\s\-:]+([\w\+\/=]+).*\n//gmi;
  my $checksumData = $data;
  $checksumData =~ s/\r//g;
  $checksumData =~ s/\n+/\n/g;
  my $checksum = md5_base64($checksumData);
  if ($checksum eq $oldchecksum)
  {
    $data = ();
	  next;
  }
  my @months = qw(January February March April May June July August September October November December);
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
  $year += 1900;
  my $todaysdate = "$months[$mon] $mday $year, $hour:$min:$sec";
  $data =~ s/(^.*!.*Updated:\s*)(.*)\s*$/$1$todaysdate/gmi;
  $checksumData = $data;
  $checksumData =~ s/\r//g;
  $checksumData =~ s/\n+/\n/g;
  $checksum = md5_base64($checksumData);
  $data =~ s/(\r?\n)/$1! Checksum: $checksum$1/;
  writeFile($file, $data);
  $data = ();
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
sub writeFile
{
  my ($file, $contents) = @_;
  open(local *FILE, ">", $file) || die "Could not write file '$file'";
  binmode(FILE);
  print FILE $contents;
  close(FILE);
}