#!/usr/bin/perl
#
# auto blocks ip from web access log
# by pyh <yonghua.peng@gmail.com>
#
use strict;
use Net::IP::CMatch;

if ($< != 0) {  # run only with root
   exit 1;
}

my $log = "/data2/log/nginx/pay.access.log";
my $whitelist = "/data/sa/pay_allow_list.conf";
my $iptables = '/sbin/iptables';
my %ips;

##restore();  # clean the old iptables

my @white_ip;
open HD, "<", $whitelist or die $!;
while(<HD>) {
    next unless /^\d+\.\d+\.\d+\.\d+(\/\d+)?/;
    push @white_ip,$&;
}
close HD;

open FD,"tail -10000 $log|" or die $!;
while(<FD>) {
##    next unless /POST \/checkUserExist\.action/;
    next unless /\.action|security_code/;
    if (/^(\d+\.\d+\.\d+\.\d+)\s+/) {
        my $ip = $1;
        $ips{$ip} ++;
    }
}
close FD;

#use Data::Dumper;
#print Dumper \%ips;

open HDW,">>","/tmp/ip.drop" or die $!;

for (sort {$ips{$b} <=> $ips{$a}} keys %ips) {
    next if ifWhite($_);
    last if $ips{$_} < 150;
    print HDW $_," ",$ips{$_},"\n";
    system "$iptables -A INPUT -s $_  -j DROP";
}

close HDW;

sub restore {
    my $file = "/tmp/ip.drop";
    return unless -f $file;
    open HD,$file or die $!;
    while (<HD>) {
        my $ip = (split)[0];
        system "$iptables -D INPUT -s $ip -p tcp --dport 80  -j DROP";
        system "$iptables -D INPUT -s $ip -p tcp --dport 443 -j DROP";
    }
    close HD;
}


sub ifWhite {
    my $ip = shift;
    my $matched = 0;

    for (@white_ip) {
        if (match_ip($ip,$_) ) {
            $matched = 1;
            last;
        }
    }

    return $matched;
}
