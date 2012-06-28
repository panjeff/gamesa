#!/usr/bin/ruby

x = [3,2,4,0,1]

class Array
   def myeach
       for i in self do
          yield i
       end
   end
end

x.myeach {|s| puts s }
