#!/usr/bin/ruby
require 'net/http'
require 'uri'
    
url = URI.parse('http://bj.ganji.com/ershoubijibendiannao/')
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
}
puts res.body

