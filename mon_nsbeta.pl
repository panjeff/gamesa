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

my @email = ('yhpang@163.com');
my @nameservers = qw(209.141.54.207  78.110.173.207 68.171.100.100);

my $hostname = hostname;  
my $ua = LWP::UserAgent->new;  
$ua->agent("Mozilla/8.0");
$ua->timeout(30);

for my $host (@nameservers) {

     my $url = "http://$host/";
     my $req = HTTP::Request->new(GET => $url);
     $req->header('Accept' => 'text/html');
     my $res = $ua->request($req);

     if ( ! $res->is_success) { 
         sendmail($url);  
     } 
}

sub sendmail { 

    my $url = shift;
    my $time = strftime "%Y-%m-%d %H:%M:%S",localtime;
    my $smtp = Net::SMTP->new('smtp.126.com',
                           Hello => $hostname,
                           Timeout => 30,
                           Debug   => 0,
                         );

    $smtp->auth("duowansmtp","***");
    $smtp->mail('duowansmtp@126.com');
    $smtp->recipient(@email);

    $smtp->data();
    $smtp->datasend("From: duowansmtp\@126.com\n");
    $smtp->datasend("To: yhpang\@163.com\n");
    $smtp->datasend("Subject: Cloud Web error\n");
    $smtp->datasend("\n");
    $smtp->datasend("[$time] open $url fail\n");
    $smtp->dataend();

    $smtp->quit;
}

