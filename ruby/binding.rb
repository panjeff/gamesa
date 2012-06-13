#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "amqp"

# Binding a queue to an exchange
AMQP.start("amqp://guest:admin@localhost") do |connection, open_ok|
  channel = AMQP::Channel.new(connection)
  exchange = channel.fanout("my_fanout")

  channel.queue("", :auto_delete => true, :exclusive => true) do |queue, declare_ok|
    queue.bind(exchange)
    puts "Bound #{queue.name} to #{exchange.name}"

    connection.close {
      EventMachine.stop { exit }
    }
  end
end
