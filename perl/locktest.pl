#! /usr/bin/perl

use strict;
use warnings;

use Fcntl ':flock'; 

$| = 1;

my $file = shift;
die "specify file to lock\n" unless ( defined $file );

print &date," open file $file\n";
open(FILE,'>>',$file) || die "open $file failed: $!";


print &date," Try to lock $file...\n";
flock(FILE,LOCK_EX) || die "flock $file failed: $!";
print &date," File locked\n";

sleep 20;

print &date," Release lock...\n";
flock(FILE,LOCK_UN) || die "release lock on $file failed: $!";
print &date," Lock released\n";

sub date {
    my $t = shift // time;
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime $t;
    sprintf("%02d:%02d:%02d",$hour,$min,$sec);
}
