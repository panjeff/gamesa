require 'rubygems'  
require "uuid"  
require 'dbi'

dbh = DBI.connect('DBI:Mysql:test','root','')
sth = dbh.prepare("insert into mytest(name,value) values (?,?)")
arr = []
val = ""
1024.times { val<< "t" }

10.times do
  arr << Thread.new {
      1000.times {
          key = UUID.new.generate 
          sth.execute(key,val)
      }
  }
end

arr.each {|t| t.join }
