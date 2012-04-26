#!/usr/bin/perl
use strict;
use Net::RabbitMQ;

my $channel = 1001;
my $queuename = "pyh_queue";
my $mq = Net::RabbitMQ->new();

$mq->connect("localhost", { vhost=>"/pyhtest", user => "pyh", password => "pyh3214" });
$mq->channel_open($channel);

while (1) {
    my $hashref = $mq->get($channel, $queuename);
    last unless defined $hashref;
    print $hashref->{message_count}, ": ", $hashref->{body},"\n";
}

$mq->disconnect();
