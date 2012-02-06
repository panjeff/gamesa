#!/usr/bin/perl

my $len = shift || 16;
my @x = (0..9,"A".."Z","a".."z");
my $str = join '', map { $x[int rand @x] } 1..$len;
print $str,"\n";
