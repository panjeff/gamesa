
require 'rubygems'  # not necessary for Ruby 1.9
require 'mongo'

db = Mongo::Connection.new.db("mytestdb")
#db.collection_names.each { |name| puts name }
coll = db.collection("foo")

doc = {"name" => "MongoDB", "type" => "database", "count" => 1,
       "info" => {"x" => 203, "y" => '102'} }

#coll.insert(doc)

#doc["name"] = "MongoDB Ruby"
#coll.update({"_id" => doc["_id"]}, doc)

#my_doc = coll.find_one()
#puts my_doc.inspect

#coll.find().each { |row| puts row.inspect }
coll.find("i" => 7).each { |row| puts row.inspect }

#10.times { |i| coll.insert("i" => i) }
