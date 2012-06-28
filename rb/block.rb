x = [3,1,4,2,9,0]

class Array
    def myfind
       if block_given?
           z = []
           each {|s| z << s if yield s}
           z
       else
           raise "no block given"
       end
    end
end

z = x.myfind {|s| s < 3}
p z
