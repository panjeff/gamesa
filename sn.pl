#!/usr/bin/perl
use strict;
use DNS::SerialNumber::Check;

my $sn = DNS::SerialNumber::Check->new;
my $re = $sn->check("cloudwebdns.com");  # or,
#my $re = $sn->check("cloudwebdns.com",['ns1.cloudwebdns.com','ns2.cloudwebdns.com']);

print $re->status,"\n";
use Data::Dumper;
print Dumper $re->info;
