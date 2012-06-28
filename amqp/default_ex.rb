#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "amqp"

EventMachine.run do
  AMQP.connect(:host => '127.0.0.1',:user => 'guest',:password => 'duowanadmin') do |connection|
    puts "Connected. AMQP Version #{AMQP::VERSION}"

    channel  = AMQP::Channel.new(connection)

    channel.queue("hello.world", :auto_delete => true).subscribe do |payload|
      puts "Received a message: #{payload} Shutdown..."

      connection.close { EventMachine.stop }
    end

    channel.direct("").publish("Greetings, world!", :routing_key => "hello.world")
  end
end

