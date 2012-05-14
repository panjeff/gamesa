#!/usr/bin/perl
use strict;
use Net::DNS;
use POSIX 'strftime';
use Email::Send::126;

my $debug = 0;
my @email = qw/yhpang@163.com/;
my $test_rr = 'cloudcache.net';
my $test_val = '50.31.252.20';  
my @nameservers = qw/174.140.172.238 204.12.223.15 216.27.27.174 68.171.100.100 62.141.35.111/;

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
           sendmail( "Cloud DNS wrong: $ns" );
           print "$ns wrong\n";
        }
        if ($debug) {
           print "$ns expected value for $test_rr: $test_val\n";
           print "$ns got value for $test_rr: ", $rr[0]->address,"\n";
        }
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
