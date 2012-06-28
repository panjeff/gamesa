require 'rubygems'
require 'dbi'
require 'iconv'

dbh = DBI.connect('DBI:Mysql:svradm','root','123456789')
sth = dbh.prepare("select * from servers")

sth.execute

while row = sth.fetch do
   puts Iconv.conv('utf-8','gb2312', row[4])
end 
