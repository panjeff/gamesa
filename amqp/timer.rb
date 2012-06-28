#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "amqp"

EventMachine::run {
   puts "Starting the run now: #{Time.now}"
   EventMachine::add_timer(2) { puts "Executing timer event: #{Time.now}" }
   EventMachine::add_timer(4) { puts "Executing timer event: #{Time.now}" }
}
