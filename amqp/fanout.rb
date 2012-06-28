#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "amqp"

AMQP.start("amqp://guest:duowanadmin@localhost") do |connection, open_ok|
  channel = AMQP::Channel.new(connection)
  exchange = channel.fanout("amq.fanout")

  10.times do
    q = channel.queue("", :exclusive => true, :auto_delete => true).bind(exchange)
    q.subscribe do |payload|
      puts "Queue #{q.name} received #{payload}"
    end
  end

  # Publish some test data after all queues are declared and bound
  EventMachine.add_timer(1) { exchange.publish "Hello, fanout exchanges world!" }
  EventMachine.add_timer(2) { puts "shutdown now"; connection.close { EventMachine.stop } }
end
