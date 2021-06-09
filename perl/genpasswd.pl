#! /usr/bin/perl

use strict;
use warnings;
use Pod::Usage;
use Getopt::Long;

# Use Cracklib if available
my $cracklib = eval { require Crypt::Cracklib };

# Optionshantering
Getopt::Long::Configure( 'no_auto_abbrev', 'no_ignore_case', 'bundling' );
my %opts;
GetOptions( \%opts, 's' ) || pod2usage;
my $minchar = shift || 6;
$minchar = 6 if ( $minchar < 6 );
my $maxchar = shift || 10;
$maxchar = $minchar if ( $maxchar < $minchar );

my $randdev = exists( $opts{s} ) ? '/dev/random' : '/dev/urandom';
open( RND, '<:bytes', $randdev ) || die "open $randdev failed: $!";

my @letters = ( 'a' .. 'z', 'A' .. 'Z' );

# Bara de specialtecken som är placerade lika både på svenskt och
# amerikanskt tangentbord.
my @special = ( '!', '#', '%' );

my @numbers = ( '0' .. '9' );
my @all = ( @letters, @special, @numbers );

# Try to construct one good password, but max 100 tries.
for ( 1 .. 100 ) {
    my $length = int rand($maxchar - $minchar + 1) + $minchar;    # 6-12
    my $password;
    for ( 1 .. $length ) {
        my $twobytes;
        read( RND, $twobytes, 2 );
        my $rand = unpack("%S2",$twobytes);  # 16-bit (0 - 65535)
        $password .= @all[ $rand % @all ];
    }
    if ( &passok($password) ) {
        print "$password\n";
        last;
    }
}

close(RND);

sub passok {
    $_ = shift;
    if ($cracklib) {
        # The good check
        return Crypt::Cracklib::check($_);
    }

    # The very minimal basic check
    if ( length($_) < 8 ) {
        return ( /[a-z]/ && /[A-Z]/ && /[0-9!#%]/ );
    }
    return ( ( /[a-z]/ && /[A-Z]/ ) || ( /[a-zA-Z]/ && /[0-9!"%]/ ) );
}

=head1 NAME

genpasswd - Generate random passwords.

=head1 SYNOPSIS

B<genpasswd>
S<[ B<-s> ]>
S<[ I<min> ]>
S<[ I<max> ]>

=head1 OPTIONS

=over 2

=item B<-s>

secure - Use F</dev/random> as random source, without B<-s> use
F</dev/urandom>

=item I<min>

Min nr of characters in password to generate. Default, and lowest
possible value is 6.

=item I<max>

Max nr of characters in password to generate. Default is 10, and 6 is
lowest possible.

=back

=head1 VERSION

$Revision: /main/8 $

=cut
