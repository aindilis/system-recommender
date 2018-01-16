#!/usr/bin/perl -w

use Data::Dumper;

my $items = 4;
my ($width, $height) = (100,15 * (int($items / 60) + 1));
my $rows = int($items / $height) + 1;
my $rowwidth = $width / $rows;
my $margin = $rowwidth - 1;

print Dumper
  ({
    Width => $width,
    Height => $height,
    Rows => $rows,
    RowWidth => $rowwidth,
    Margin => $margin,
   });
