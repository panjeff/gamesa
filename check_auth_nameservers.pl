#!/usr/bin/perl
use strict;
use Net::DNS;
use POSIX 'strftime';
use Email::Send::126;
use MySQL::Easy::PYH;

my $debug = 0;
my $db = MySQL::Easy::PYH->new("dwdns");
my @email = qw/yhpang@163.com/;   # the email for receiving warns
my $test_rr = 'vary.game.yy.com'; # the record for test
my @nameservers = qw/113.108.228.172 58.215.191.68 125.90.88.106 182.118.1.100/;

my $val1 = int(rand 250) + 1;
my $val2 = int(rand 250) + 1;
my $val3 = int(rand 250) + 1;
my $val4 = int(rand 250) + 1;
my $val = "$val1.$val2.$val3.$val4";  # a random IP

# update the test value to the random IP
$db->do_sql("update records set status=2 where label='vary'");
$db->do_sql("insert into records (label,zid,rtype,rdata,ttl,ctime,status,isp) values
           ('vary',4,'A','$val',30,now(),0,'any')");
$db->do_sql("insert into records (label,zid,rtype,rdata,ttl,ctime,status,isp) values
           ('vary',4,'A','$val',30,now(),0,'uni')");

sleep 15; # wait for the DNS to become effective

for my $ns (@nameservers) {
    test_query($ns);
}

sub test_query {
    my $ns = shift;
    my $res = Net::DNS::Resolver->new(nameservers => [$ns]);
    my $answer = $res->query($test_rr);

    if (defined $answer) {
        my @rr = $answer->answer;
        if ($rr[0]->address ne $val) {
           sendmail( "$ns同步错误" );
           print "$ns sync error\n";
        }
        if ($debug) {
           print "$ns expected value: $val\n";
           print "$ns got value: ", $rr[0]->address,"\n";
        }
    }
}

sub sendmail {
    my $mesg = shift;
    my $time = strftime '%Y-%m-%d %H:%M:%S',localtime;

    my $subject = "DNS告警";
    my $data =<<EOF;
时间：$time<BR>
异常情况：$mesg<BR>
EOF

    my $smtp = Email::Send::126->new("duowansmtp","***");
    $smtp->sendmail($subject,$data,@email);
}
