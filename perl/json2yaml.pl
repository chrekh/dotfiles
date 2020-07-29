#! /usr/bin/perl

use strict;
use warnings;

use JSON;
use YAML;

if ( @ARGV ) {
    for my $f ( @ARGV ) {
	open(F,'<',$f) || die "open $f failed: $!";
	local $/;
	&json2yaml(<F>);
	close(F);
    }
}
else {
    &json2yaml(<STDIN>)
}

sub json2yaml {
    my $jsonstr = shift;
    my $data = from_json( $jsonstr, { utf8 => 1 } );
    print Dump($data);
}
