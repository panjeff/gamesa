#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "amqp"

AMQP.start("amqp://guest:duowanadmin@localhost") do |connection, open_ok|
  channel = AMQP::Channel.new(connection)
  exchange = channel.direct("amq.direct")

  q = channel.queue("", :exclusive => true, :auto_delete => true).bind(exchange, :routing_key => "hello.world")
  q.subscribe do |payload|
      puts "Queue #{q.name} received #{payload}"
  end

  # Publish some test data after all queues are declared and bound
  EventMachine.add_timer(0.5) { exchange.publish("Hello, direct exchanges world!",:routing_key => "hello.world") }
  EventMachine.add_timer(1) { puts "shutdown now"; connection.close { EventMachine.stop } }
end
