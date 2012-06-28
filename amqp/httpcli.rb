#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'

module HttpHeaders 
  def post_init
    send_data "GET /\r\n\r\n"
    @data = ""
  end
  
  def receive_data(data)
    @data << data
  end
  
  def unbind
    if @data =~ /[\n][\r]*[\n]/m
      $`.each {|line| puts ">>> #{line}" }
    end
    
    EventMachine::stop_event_loop
  end
end

EventMachine::run do
  EventMachine::connect 'google.com', 80, HttpHeaders
end
