class StringHolder
  attr_reader :string
  def initialize(string)
    @string = string
  end
end

class Object
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end
end

s1 = StringHolder.new('string')
s2 = s1.deep_copy

s1.string[1] = 'p'

puts s1.string
puts s2.string
