require 'rubygems'  
require 'mongo'
require "uuid"  

db = Mongo::Connection.new.db("mytestdb")
coll = db.collection("test")
arr = []
val = ""
1024.times { val<< "t" }

10.times do
  arr << Thread.new {
      1000.times {
          key = UUID.new.generate 
          coll.insert(key => val)
      }
  }
end

arr.each {|t| t.join }
