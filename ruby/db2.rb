require 'rubygems'
require 'dbi'

DBI.connect('DBI:Mysql:test','root','') do |dbh|

    sql = "insert into t1 (name,sex,city,mobile) values (?,?,?,?)";

    dbh.prepare(sql) do |sth|
        sth.execute('John Doe','M','Archer','4076320942')
    end

    dbh.prepare("select * from t1") do |sth|
        sth.execute
        sth.fetch do |row|
           p row
        end
    end
end

