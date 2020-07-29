#! /usr/bin/perl

use strict;
BEGIN {
    use locale;
}
use YAML qw<Load Dump>;

my $f = shift;

my $from = {};
my $to = {};

{
    open( FILE, '<:utf8', $f ) || die "open $f failed: $!";
    local $/;    # slurp mode
    ($from) = Load(<FILE>);
}

for my $key ( keys %{$from} ) {
    $to->{$key} = $from->{$key}
}


binmode( STDOUT, ':utf8' );
print Dump($to);

1;
