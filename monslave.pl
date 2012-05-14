#!/usr/bin/perl
use strict;
use POSIX 'strftime';
use MySQL::Easy::PYH;
use Email::Send::126;

my @email = qw(yhpang@163.com);
my $host = 'slavedb1.***.com';
my @ports = qw(3307 3308 3309 3310);

for my $port (@ports) {
    if ( ! check_slave($host,$port) ) {
        sendmail($host,$port,"Slave线程终止");
    }
}

sub check_slave {

    my $host = shift;
    my $port = shift;
    my $db;

    eval {
        local $SIG{'__WARN__'} = sub {};
        $db = MySQL::Easy::PYH->new("mysql","127.0.0.1",$port,'root','***');
    };

    if ($@) {
        sendmail($host,$port,"MySQL服务停止");
        exit;
    }

    my @re = $db->get_row("show slave status");
    return ($re[10] eq 'Yes' && $re[11] eq 'Yes') ? 1 : 0;
}

sub sendmail {

    my $host = shift;
    my $port = shift;
    my $mesg = shift;
    my $time = strftime '%Y-%m-%d %H:%M:%S',localtime;

    my $subject = "MySQL从库告警";
    my $data =<<EOF;
时间：$time<BR>
数据库主机：$host<BR>
数据库端口：$port<BR>
异常情况：$mesg<BR>
EOF

    my $smtp = Email::Send::126->new("duowansmtp","***");
    $smtp->sendmail($subject,$data,@email);
}
