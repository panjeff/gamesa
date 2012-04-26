#!/usr/bin/perl
use strict;
use Net::SMTP;
use LWP::UserAgent;
use Sys::Hostname;
use POSIX 'strftime';

eval {
    require MIME::Base64;
    require Authen::SASL;
} or die "MIME::Base64 and Authen::SASL are required\n"; 

###################################
# You must change the values below
###################################
my $url = 'http://www.dnsbed.com/';
my @email = ('yhpang@163.com');

##################################
my $hostname = hostname;  # needed for sending email
my $ua = LWP::UserAgent->new;  # the useragent object
$ua->agent("Mozilla/8.0");
$ua->timeout(30);

my $req = HTTP::Request->new(GET => $url);
$req->header('Accept' => 'text/html');
my $res = $ua->request($req);

if ( ! $res->is_success) {  # access url fail
    sendmail();  # send email for notice
} else {
##   print "OK\n";
}

sub sendmail { 

    my $time = strftime "%Y-%m-%d %H:%M:%S",localtime;
    my $smtp = Net::SMTP->new('smtp.126.com',
                           Hello => $hostname,
                           Timeout => 30,
                           Debug   => 0,
                         );

    $smtp->auth("duowansmtp","*");
    $smtp->mail('duowansmtp@126.com');
    $smtp->recipient(@email);

    $smtp->data();
    $smtp->datasend("From: duowansmtp\@126.com\n");
    $smtp->datasend("To: yhpang\@163.com\n");
    $smtp->datasend("Subject: website error\n");
    $smtp->datasend("\n");
    $smtp->datasend("[$time] open $url fail\n");
    $smtp->dataend();

    $smtp->quit;
}

