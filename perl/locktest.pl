#! /usr/bin/perl

#
# Test file locking using fcntl()
#

use strict;
use warnings;

use Fcntl;

$| = 1;

my $file = shift;
die "specify file to lock\n" unless ( defined $file );

print &date," open file $file\n";
open(FILE,'>>',$file) || die "open $file failed: $!";

my $flags = &pack_flockflags(F_WRLCK);
print &date," Try to lock $file...\n";
fcntl(FILE,F_SETLKW,$flags) || die "lock $file failed: $!";
print &date," File locked\n";

sleep 20;

print &date," Release lock...\n";
$flags = &pack_flockflags(F_UNLCK);
fcntl(FILE,F_SETLK,$flags) || die "unlock $file failed: $!";
print &date," Lock released\n";

sleep 20;

sub date {
    my $t = shift // time;
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime $t;
    sprintf("%02d:%02d:%02d",$hour,$min,$sec);
}

sub pack_flockflags {
    my $kind = shift;
    return pack( 'ssx4qqlx4',
		 $kind, # l_type
		 0,     # l_whence
		 0,     # l_start
		 0,     # l_len
		 0,     # l_pid
		 );
}
