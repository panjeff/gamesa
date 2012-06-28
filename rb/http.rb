#!/usr/bin/ruby
require 'net/http'
require 'uri'
    
url = URI.parse('http://udb.duowan.com/message/loginforseq')

req = Net::HTTP::Post.new(url.path)
req.set_form_data({'username'=>'pyhtest', 'password'=>'***'})

res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }

case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      puts res.body
    else
      puts res.error!
end
