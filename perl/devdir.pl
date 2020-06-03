#! /usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use File::Basename;

my %opts;
GetOptions(\%opts,'v') || die;

for my $d ( @ARGV ) {
    next unless ( -d $d );
    my ($dev) = stat _;
    die "stat '$d' failed: $!" unless ( defined $dev );
    my $parent = dirname $d;
    my ($pardev) =  stat $parent;
    if ( $pardev == $dev ) {
        print "$d\n" unless ( exists $opts{v} );
    }
    else {
        print "$d\n" if ( exists $opts{v} );
    }
}
