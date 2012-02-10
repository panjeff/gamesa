#!/usr/bin/perl
use strict;
use LWP::UserAgent;
use Benchmark::Timer;

my @childs;
my @urls;
my $ua = LWP::UserAgent->new;

for (1..300) {
   my $ip = getip();
   push @urls, "http://xxx.com:8080/iploc/?ip=$ip";
}

my $t = Benchmark::Timer->new();
my $max = 3; # process number
$t->start('tag');

for (1..$max) {

   my $child = fork;
   if ($child) {
      push(@childs, $child);

   } else {
     for (@urls) {
         httptest($_);
     }
     exit 0;
   }
}

for (@childs) {
    my $tmp = waitpid($_, 0);
    print "done with pid $tmp\n";
}      

$t->stop('tag');
my $time = sprintf("%.2f",$t->result('tag'));
print "fetches per second: ", int( (300*$max)/$time ), "\n";

sub httptest {

  my $url = shift;

  my $req = HTTP::Request->new(GET => $url);
  $req->header('Accept' => 'text/html');

  my $res = $ua->request($req);

  if ($res->is_success) {
     ## print $res->decoded_content;
  } else {
     print "Error: " . $res->status_line . "\n";
  }
}

sub getip {
   my $a1 = int(rand(254))+1;
   my $a2 = int(rand(254))+1;
   my $a3 = int(rand(254))+1;
   my $a4 = int(rand(254))+1;

   "$a1.$a2.$a3.$a4";
}
