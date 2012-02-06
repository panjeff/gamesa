#!/usr/bin/perl
use strict;
use Net::RabbitMQ;
use Data::Dumper;
use UUID::Tiny;

my $channel = 1;
my $queuename = "myqueue2";
my $exchange = "myexch2";
my $routing_key = "test";

my $mq = Net::RabbitMQ->new();

$mq->connect("localhost", { user => "guest", password => "guest" });
$mq->channel_open($channel);
$mq->exchange_declare($channel, $exchange, {durable => 0});
$mq->queue_declare($channel, $queuename, {durable => 0});
$mq->queue_bind($channel, $queuename, $exchange, $routing_key);


for (my $i=0;$i<30000000;$i++) {
###    my $string =  create_UUID_as_string(UUID_V1);
    my $string = "42013bc9-fac5-11e0-8977-eb90bd6a28cc";
    $mq->publish($channel, $routing_key, $string, { exchange => $exchange }, { delivery_mode => 0 });
}


$mq->disconnect();
