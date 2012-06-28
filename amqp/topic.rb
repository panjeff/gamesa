#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems" # or use Bundler.setup
require "amqp"

EventMachine.run do
  AMQP.connect(:host => '127.0.0.1',:user => 'guest',:password => 'duowanadmin') do |connection|
    channel  = AMQP::Channel.new(connection)
    exchange = channel.topic("pub/sub", :auto_delete => true)

    # Subscribers
    channel.queue("", :exclusive => true) do |queue|
      queue.bind(exchange, :routing_key => "americas.north.#").subscribe do |metadata, payload|
        puts "Got data: #{payload}, routing key is #{metadata.routing_key}"
      end
    end

    # publish updates 1 second later, after all queues are declared and bound
    EventMachine.add_timer(1) do
        exchange.publish("Berkeley update", :routing_key => "americas.north.us.ca.berkeley")
    end

    show_stopper = Proc.new { connection.close { EventMachine.stop } }

    Signal.trap "TERM", show_stopper
    EM.add_timer(3, show_stopper)
  end
end
