#!/usr/bin/perl
use strict;
use MySQL::Easy::PYH;

my $action = shift;                # 1 for repair
my $database = 'db_name'; # database name

my $db = MySQL::Easy::PYH->new($database,'localhost',3306,'root','****');
my $rows = $db->get_rows("show tables");

for my $r (@$rows) {
    my $string = "Tables_in_" . $database;
    my $table = $r->{$string};

    eval {
        local $SIG{'__WARN__'} = sub {};
        $db->get_row("show create table $table");
    };

    if ($@ ) {
        print $table, " bad\n";
        if ($action) {
            $db->do_sql("repair local table $table");
            print $table," repaired\n";
        }
    }
}

$db->disconnect;
