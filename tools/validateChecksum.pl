#!/usr/bin/perl

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