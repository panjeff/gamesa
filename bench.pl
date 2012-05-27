use strict;
use Benchmark::Timer;

my $t = Benchmark::Timer->new;

for(1 .. 10) {
    $t->start('tag');
    with_split();
    $t->stop('tag');
}
print "with split: ",$t->report;

$t->reset;

for(1 .. 10) {
    $t->start('tag');
    with_regex();
    $t->stop('tag');
}
print "with regex: ",$t->report;


sub with_split {
    open my $fd,"data.txt" or die $!;
    while(<$fd>) {
        chomp;
        my ($user,$shell) = (split/:/)[0,-1];
    }
    close $fd;
}

sub with_regex {
    my $regex = qr/^(.*?)\:.*\:(.*)$/;
    open my $fd,"data.txt" or die $!;
    while(<$fd>) {
        my ($user,$shell) = $_ =~ $regex;
    }
    close $fd;
}
