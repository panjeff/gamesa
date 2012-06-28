use strict;
use AnyEvent;

$| = 1; print "enter your name ->\n";
my $name;
my $name_ready = AnyEvent->condvar;

my $wait_for_input = AnyEvent->io (
   fh   => \*STDIN,
   poll => "r",
   cb   => sub {
      $name = <STDIN>;
      $name_ready->send;
   }
);

# do something else here
for (1..5) {
    print ".";
    sleep 1;
}

# now wait until the name is available:
$name_ready->recv;
undef $wait_for_input;
print "your name is $name\n";
