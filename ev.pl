#!/usr/bin/perl
use strict;
use POSIX 'strftime';
use Data::Dumper;
use Net::Evernote;
use encoding 'utf8';

my$username = "kenpeng";
my$password = "***";
my$consumerKey= "kenpeng";
my$consumerSecret = "***";

my$note = Net::Evernote->new($username,$password,$consumerKey,$consumerSecret);

my $title = "印象笔记". strftime("%Y-%m-%d %H:%M:%S",localtime);
my $content =<<EOF;
    申请开通入口机访问权限
    door1.game.yy.com
    door2.game.yy.com
EOF

##write a note
my $res = $note->writeNote($title, $content);

# get the note
my $thisNote = $note->getNote($res->guid);
print $thisNote->title,"\n";
print $thisNote->content,"\n";

# delete the note
#$note->delNote($res->guid);

# search
my $rr = $note->findNotes("印象笔记",0,10);
for my $thisNote ( @{$rr->notes} ) {
    print $thisNote->guid,"\n";
    print $thisNote->title,"\n";
}
 
