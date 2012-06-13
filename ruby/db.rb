require 'rubygems'
require 'dbi'

dbh = DBI.connect('DBI:Mysql:test','root','')
#sth = dbh.prepare("insert into t1 (name,sex,city,mobile) values (?,?,?,?)")
#sth.execute('John Doe','M','Archer','4076320942')
#sth.finish

sth = dbh.prepare("select * from t1")
sth.execute
while row = sth.fetch do
  p row
end

sth.finish
dbh.disconnect

