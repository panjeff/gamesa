#!/usr/bin/perl
use strict;
use Net::RabbitMQ;
use Data::Dumper;
use UUID::Tiny;

my $channel = 1000;
my $queuename = "pyh_queue";
my $exchange = "pyh_exchange";
my $routing_key = "test";

my $mq = Net::RabbitMQ->new();

$mq->connect("localhost", { vhost => "/pyhtest", user => "pyh", password => "pyh3214" });
$mq->channel_open($channel);
$mq->exchange_declare($channel, $exchange, {durable => 1});
$mq->queue_declare($channel, $queuename, {durable => 1});
$mq->queue_bind($channel, $queuename, $exchange, $routing_key);


for (my $i=0;$i<5000000;$i++) {
    my $string =  create_UUID_as_string(UUID_V1);
    $mq->publish($channel, $routing_key, $string, { exchange => $exchange }, { delivery_mode => 2 });
}


$mq->disconnect();
