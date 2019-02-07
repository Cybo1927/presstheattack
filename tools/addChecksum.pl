#!/usr/bin/perl

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