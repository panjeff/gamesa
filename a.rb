require 'rubygems'
require 'dbi'

dbh=DBI.new("test","root","password")
str="select * from user"
dbh.prepare(str) do |sth|
    sth.execute
    sth.fetch do |row|
        puts row
    end
 end
