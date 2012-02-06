#!/usr/bin/env ruby
require 'rubygems'
#require 'sinatra'

def make_id_card
    arr = File.new("areacode.txt").readlines.map{|s| s.chomp}
    area = arr[rand(arr.size)]

    years = (18..40).to_a
    year = years[rand(years.size)]

    x = Time.now - year * 365 * 86400
    t = x.strftime("%Y%m%d")

    y = rand(999)
    y = y > 100 ? y : y+100

    id = area.to_s + t.to_s + y.to_s 
    ida = id.split(//)
    idx = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]

    hash = {0=>'1',1=>'0',2=>'X',3=>'9',4=>'8',5=>'7',6=>'6',7=>'5',8=>'4',9=>'3',10=>'2'}
    z = 0

    ida.each do |s|
        z += s.to_i * idx.shift
    end

    id + hash[z%11]
end

puts make_id_card

#get '/' do
#    make_id_card
#end

