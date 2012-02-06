#!/usr/bin/perl
use strict;

exit unless @ARGV;

open HD,"pubdns.txt" or die $!;
while(<HD>) {
    last if /__END__/;
    chomp;
    my ($ns,$desc) = split/\#/;
    $ns=~s/^\s+|\s+$//g;
    $desc=~s/^\s+|\s+$//g;

    print "$desc ($ns):\n";
    system "idig @ARGV \@$ns";
    print "-" x 72,"\n";
}
close HD;

