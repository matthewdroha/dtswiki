#!/usr/intel/pkgs/perl/5.26.1/bin/perl


use v5.26.1;
use strict;
use warnings;
use English;
use IO::File;


my $txt = pop @ARGV;
my $txt_h;
if ($txt) {
  $txt_h = IO::File->new;
  $txt_h->open($txt) or die "Could not open .txt file for reading\n";
} else {
  die "No .txt file provided\n";
}

say q({| class="wikitable");

while (<$txt_h>) {
  chomp;
  my @record = split(/\t/, $_);
  foreach my $value (@record) {
    if ($. == 1) {
      say qq(! $value);
    } else  {
     say qq(| $value);
    }
  }
  say q(|-);
}
say q(|});
