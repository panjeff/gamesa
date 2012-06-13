class Man
   attr_reader :name,:age

   def initialize(name,age)
      @name=name
      @age=age
   end
end

man = Man.new("Michael Clark",33)
puts "#{man.name} #{man.age}"

man = Man.new("Michael III",28)
puts "#{man.name} #{man.age}"

