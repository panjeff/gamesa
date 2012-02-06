#!/usr/bin/perl
use strict;
my (@names,@values);

while(<DATA>) {
    chomp;
    my ($name,$value) = split/:/,$_;
    $name =~ s/^\s+|\s+$//g;
    $value =~ s/^\s+|\s+$//g;
    push @names,$name;
    push @values,"'" . $value . "'";
}

my $k = join ',',@names;
my $v = join ',',@values;

print "insert into user ($k) values ($v)";
print "\n\n";


__DATA__
                 Host: localhost
                 User: debian-sys-maint
             Password: *81C1CD8535ED9F40E3EF49E8EA8B23CEA7201780
          Select_priv: Y
          Insert_priv: Y
          Update_priv: Y
          Delete_priv: Y
          Create_priv: Y
            Drop_priv: Y
          Reload_priv: Y
        Shutdown_priv: Y
         Process_priv: Y
            File_priv: Y
           Grant_priv: N
      References_priv: Y
           Index_priv: Y
           Alter_priv: Y
         Show_db_priv: Y
           Super_priv: Y
Create_tmp_table_priv: Y
     Lock_tables_priv: Y
         Execute_priv: Y
      Repl_slave_priv: Y
     Repl_client_priv: Y
     Create_view_priv: Y
       Show_view_priv: Y
  Create_routine_priv: Y
   Alter_routine_priv: Y
     Create_user_priv: Y
           Event_priv: Y
         Trigger_priv: Y
             ssl_type: 
           ssl_cipher: 
          x509_issuer: 
         x509_subject: 
        max_questions: 0
          max_updates: 0
      max_connections: 0
 max_user_connections: 0
