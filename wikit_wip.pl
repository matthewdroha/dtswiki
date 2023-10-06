#!/usr/intel/pkgs/perl/5.26.1/bin/perl

use v5.26.1;
use strict;
use warnings;
use English;
use IO::File;

=c
Load tab delimited file, assume exported from Excel
Example including embedded newlines in a single cells (handle in wiki as bullet list)
Field A^IField B^IField C^M$
Item 1^IItem 2^IItem 3^M$
Item 4^IItem 5^I"Item 6a$
Item 6b$
Item 6c"^M$
Item 7^I"Item 8a$
Item 8b$
Item 8c"^IItem 9^M$
=cut


# Load txt file (tab delimited)
my $txt = pop @ARGV;
my $txt_h;
if ($txt) {
  $txt_h = IO::File->new;
  $txt_h->open($txt) or die "Could not open .txt file for reading\n";
} else {
  die "Usage: wikit.pl test.txt\n";
}

my @headerrow = ();
my @dataset = ();
while (<$txt_h>) {
  chomp;
  next unless (/\S+/);
  # strip out dos CR and newline combo
  s/\r\n//g;
  my @record = split(/\t/, $_);
  
  my $bulletlist = 0;
  foreach my $value (@record) {
    $value =~ s/^\s+//;
    if ($. == 1) {
      push(@headerrow, $value);
      next;
    }
    if ($bulletlist) {
    } else {
      push(@{ $dataset[$.] }, $value);
    }

    if ($value =~ /\"/) {

    }
  }
}

say q({| class="wikitable");
say q(|-);
foreach my $header (@headerrow) {
  say qq(! $header);
}
say q(|-);
foreach my $row (@dataset) {
  foreach my $value (@{ $row }) {
    say qq(| $value);
  }
  say q(|-);
}
say q(|});
