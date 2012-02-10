#!/usr/bin/perl
use strict;
use Net::SSH::Perl;
use MySQL::Easy::PYH;
use Encode;

my $db = MySQL::Easy::PYH->new("svradm",undef,undef,"root","***");
my $rows = $db->get_rows("select ip_eth0,uses from servers");

for my $r (@$rows) {
    my $use = encode "utf8", decode("gb2312",$r->{uses});
    $use =~ s/^\s+|\s+$//g;
    next if ($use =~ /弹弹堂/ or $use =~ /水煮江山/ or $use =~ /僵尸/);

    my $ip;
    if ($r->{ip_eth0} =~ /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/) {
        $ip = $1;
    } else {
        next;
    }

    next unless port_scan($ip,9022);

    my $ssh = Net::SSH::Perl->new($ip,port=>9022);
    my $user = $use =~ /爆爆堂/ ? 'gamesa' : 'pyh';
    my $message = 0;

    eval {
        local $SIG{ALRM} = sub { die "alarm\n" };
        alarm 8;
        $ssh->login($user);
        alarm 0;
    };
    alarm 0;

    if (! $@) {
        my ($stdout, $stderr, $exit) = $ssh->cmd("netstat -ts|grep 'connections established'");
        ($message) = $stdout =~ /(\d+) connections established/;
    }

    $message --;  # net::ssh open one connection
    if ($message < 5) {
        printf "%-20s%-50s\n",$ip,$use ." ($message)";
    }
}

sub port_scan {

    my $host = shift;
    my $port = shift;

    my $sock=IO::Socket::INET->new(PeerAddr => $host,
                                   PeerPort => $port,
                                   Proto    => 'tcp',
                                   Timeout  => 10);

    return defined $sock ? 1 : 0;
}

