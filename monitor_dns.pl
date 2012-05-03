#!/usr/bin/perl
use strict;
use Net::DNS;
use POSIX 'strftime';
use Email::Send::126;
  
my @email = qw/yhpang@163.com/;
my $domain_name = "alive.game.yy.com";
my $domain_value = "121.9.221.187";

test_query('tel','119.147.163.133');
test_query('cnc','219.129.239.5');

sub test_query {
    my $isp = shift;
    my $ns = shift;
    my $res = Net::DNS::Resolver->new(nameservers => [$ns]);
    my $answer = $res->query($domain_name);
    my %cnisp = ('tel'=>'电信','cnc'=>'网通');

    if (defined $answer) {
        my @rr = $answer->answer;
        if ($rr[0]->address ne $domain_value) {
           sendmail( $cnisp{$isp}."DNS查询错误" );
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
