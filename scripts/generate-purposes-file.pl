#!/usr/bin/perl -w

use PerlLib::HTMLConverter;

use Data::Dumper;

my $conv = PerlLib::HTMLConverter->new;

my @res;
foreach my $item (qw(internal external minor)) {
  my $f = "/var/lib/myfrdcsa/codebases/internal/fweb/data/www/frdcsa/$item/index.html";
  my $c = `cat "$f"`;
  push @res, $conv->ConvertToTxt(Contents => $c);
}
my $text = join("\n\n",@res);

my $count;
foreach my $token (split /\W/, $text) {
  $count->{$token}++;
}

if (0) {
  my @sorted = sort {$count->{$b} <=> $count->{$a}} keys %$count;
  my @top = splice @sorted, 0, 150;
  foreach my $token (@top) {
    print $count->{$token}."\t".$token."\n";
  }
}

print Dumper({1 => $text});
