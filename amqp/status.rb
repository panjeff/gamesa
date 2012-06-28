require 'rubygems'
require 'amqp'

puts "=> Queue#status example"
puts
AMQP.start("amqp://guest:duowanadmin@localhost") do |connection|
  channel   = AMQP::Channel.new(connection)

  queue_name = "my_queue"
  exchange   = channel.fanout("my_exchange", :auto_delete => true)
  queue      = channel.queue(queue_name, :auto_delete => true).bind(exchange)

  100.times do |i|
    print "."
    exchange.publish(Time.now.to_i.to_s + "_#{i}", :key => queue_name)
  end
  $stdout.flush

  EventMachine.add_timer(0.5) do
    queue.status do |number_of_messages, number_of_consumers|
      puts
      puts "# queue #{queue.name} has messages #{number_of_messages}, has consumer #{number_of_consumers}"
      puts
      queue.purge
    end
  end


  show_stopper = Proc.new do
    $stdout.puts "Stopping..."
    connection.close { EventMachine.stop }
  end

  Signal.trap "INT", show_stopper
  EventMachine.add_timer(2, show_stopper)
end
