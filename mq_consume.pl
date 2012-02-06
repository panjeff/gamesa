#!/usr/bin/perl
use strict;
use Net::RabbitMQ;
use Data::Dumper;
use UUID::Tiny;

my $channel = 1;
my $queuename = "myqueue";
my $exchange = "myexch";
my $routing_key = "test";

my $mq = Net::RabbitMQ->new();

$mq->connect("localhost", { user => "guest", password => "guest" });
$mq->channel_open($channel);
$mq->exchange_declare($channel, $exchange, {durable => 1});
$mq->queue_declare($channel, $queuename, {durable => 1});
$mq->queue_bind($channel, $queuename, $exchange, $routing_key);


while(1){
        my $options = {
                         routing_key => $routing_key,
                         exchange => $exchange,
                      };

        my $hashref = $mq->get($channel, $queuename, $options);
        last unless defined $hashref;
        print $hashref->{message_count}, ": ", $hashref->{body},"\n";
}

$mq->disconnect();
