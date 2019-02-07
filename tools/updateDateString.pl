#!/usr/bin/perl

use strict;
use warnings;
use Time::Piece qw(localtime);
die "Usage: $^X $0 subscription.txt\n" unless @ARGV;
my $file = $ARGV[0];
my $data = readFile($file);
my $time    = localtime();
my $strDateTime = $time->strftime("%F %R JST\(UTC%z\)");
my $strVersion = $time->strftime("%Y%m%d%H%M");
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