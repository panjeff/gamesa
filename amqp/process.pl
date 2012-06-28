use strict;

$|=1;
my $pid = fork;
if ($pid) { # parent
    for (1..5) {
        print ".";
        sleep 1;
    }
} else { # child
   my $name = <STDIN>;
   print "your name is $name";
   exit 0;
}

waitpid($pid,0);
print "done\n";
