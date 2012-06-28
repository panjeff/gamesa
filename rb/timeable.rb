module Timeable
  attr_reader :time_created

  def initialize
    @time_created = Time.now
  end

   def age
     Time.now - @time_created
   end
end

class Character
   include Timeable
   def initialize(name)
      @name = name
      super()  # () is important
   end
end

p= Character.new('peter')
puts p.time_created
puts p.age
