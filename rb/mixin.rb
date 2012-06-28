require 'set'

module Taggable
  attr_accessor :tags

  def taggable_setup
    @tags = Set.new
  end

  def add_tag(tag)
    @tags << tag
  end

  def remove_tag(tag)
    @tags.delete(tag)
  end
end

class TaggableString < String
  include Taggable
#  def initialize(*args)
  def initialize(str)
    super
    taggable_setup
  end
end

s = TaggableString.new("hello world")
#p s.class.superclass
s.add_tag "nice"
s.add_tag "girl"
p s.tags
