class Myclass
    attr_accessor :file

    def myread(f)
      yield File.new(f)
    end
end

o = Myclass.new
o.file = ARGV[0] || 'ftp.rb'

puts o.file + ":"
puts

o.myread(o.file) do |handle| 
    puts handle.readlines
end
