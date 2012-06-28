#!/usr/bin/perl
use strict;
use Net::DNS;
use POSIX 'strftime';
use Email::Send::126;

my $debug = 0;
my @email = qw/yhpang@163.com/;
my $test_rr = 'cloudcache.net';
my $test_val = '199.91.172.11';  
my @nameservers = qw(ns1.cloudwebdns.com ns2.cloudwebdns.com ns3.cloudwebdns.com ns4.cloudwebdns.com);

for my $ns (@nameservers) {
    test_query($ns);
}

sub test_query {
    my $ns = shift;
    my $res = Net::DNS::Resolver->new(nameservers => [$ns]);
    my $answer = $res->query($test_rr);

    if (defined $answer) {
        my @rr = $answer->answer;
        if ($rr[0]->address ne $test_val) {
           sendmail( "DNS not matched: $ns" );
           print "$ns wrong\n";
        }
        if ($debug) {
           print "$ns expected value for $test_rr: $test_val\n";
           print "$ns got value for $test_rr: ", $rr[0]->address,"\n";
        }
    } else {
        sendmail( "Can't query to: $ns" );
        print "$ns wrong\n";
    }
}

sub sendmail {
    my $mesg = shift;
    my $time = strftime '%Y-%m-%d %H:%M:%S',localtime;

    my $subject = "Cloud DNS告警";
    my $data =<<EOF;
时间：$time<BR>
异常情况：$mesg<BR>
EOF

    my $smtp = Email::Send::126->new("duowansmtp","***");
    $smtp->sendmail($subject,$data,@email);
}
