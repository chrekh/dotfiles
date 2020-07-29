#! /usr/bin/perl

use strict;
use warnings;

use 5.010;

use GDBM_File ;

my $dbfile = shift;
die "no file" unless defined $dbfile;

my %db;
tie(%db, 'GDBM_File', $dbfile , &GDBM_READER, 0640) || die "tie failed: $!";

for my $key ( keys %db ) {
    print "$key $db{$key}\n";
}
