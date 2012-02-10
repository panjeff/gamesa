#!/usr/bin/perl
use strict;
use Net::POP3;
use Email::Send::126;
use MIME::Base64;

my $usr = 'yhpang';
my $pwd = '***';
my $pop = Net::POP3->new('pop3.163.com', Timeout => 30);
my $file = "/tmp/messages.unread";
my $oldnum = 0;
my $num = 0;

if ( -f $file ) {
    open HD, $file or die $!;
    $oldnum = <HD>;
    close HD;
}

if ($pop->login($usr, decode_base64($pwd)) > 0) {
    my $msg = $pop->list;
    my @id = sort keys %$msg;
    $num = @id;
    if ( $num >0 && $num != $oldnum) {
       my $subject = "POP3 Alert $num unread";
       my $content = "<P>You have $num messages unread in 163 mail</P>";
       my $smtp = Email::Send::126->new("duowansmtp","***"); 
       $smtp->sendmail($subject,$content,'pengyh@wo.com.cn');
    }
}

$pop->quit;

open HDW,">",$file or die $!;
print HDW $num;
close HDW;

