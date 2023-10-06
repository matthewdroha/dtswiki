#!/usr/intel/pkgs/perl/5.20.1-threads/bin/perl


use v5.20.1;
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


my %commits;
my $row = 0;

while (<$txt_h>) {
  chomp;
  my ($fix, $cdate, $message) = split(/\t/, $_);
  if ($fix =~ /Style/) { next };
  my $sortkey = join('::',$fix, $cdate, $row);
  $commits{$sortkey} = $message;
  $row++;
}

say q({| class="wikitable");
my $firstrow = 1;
foreach my $sortkey (sort {$b cmp $a} keys %commits) {
  my ($fix, $cdate) = split (/::/, $sortkey);
  my $message = $commits{$sortkey};
  my $fontcolor;
  if ($fix eq 'New') {
    $fontcolor = q(#ff9500);
  }
  elsif ($fix eq 'Improved') {
    $fontcolor = q(#3399ff);
  }
  elsif ($fix eq 'Fixed') { 
    $fontcolor = q(#00b300);
  }
  if ($fontcolor) {
    $fix = qq(style="color:white; background:${fontcolor};" | '''${fix}''');
  }
  $cdate = qq(style="white-space: nowrap;" | $cdate);


  foreach my $value ($fix, $cdate, $message) {
    if ($firstrow) {
      say qq(! $value);
    } else {
      say qq(| $value);
    }
  }
  $firstrow = 0;
  say q(|-);
}
say q(|});
