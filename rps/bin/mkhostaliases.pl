#! /usr/bin/perl

use strict;
use warnings;

use Net::Domain qw(hostdomain);
use Net::DNS;
use YAML;
use File::Basename;
use Getopt::Long qw{ :config no_ignore_case no_auto_abbrev bundling };

my %opts = ( branch => 'master' );
my @argv_orig = @ARGV;
GetOptions( \%opts, 'repo=s','dest=s','branch=s' ) || die;

# Byild alias-list for domain submitted as arg, or current domain.
my @domains = @ARGV ? @ARGV : ( hostdomain );

my %alias;
for my $dom ( @domains ) {
    &getaliases($dom);
    &writebasharray;
}

sub writebasharray {
    my $file = "$ENV{HOME}/db/aliases.bash";
    my $str;
    for my $h ( keys %alias ) {
        $str .= qq<[$h]="@{$alias{$h}}" >;
    }
    open(F,'>',$file) || die "open $file failed: $!";
    print F 'declare -A hostaliases=(',$str,")\n";
    close(F)
}

sub getaliases {
    # Try to do DNS zone-transfer to create a hash to lookup aliases from
    my $domain = shift;
    my $res = Net::DNS::Resolver->new(tcp_timeout => 10, udp_timeout => 10);
    my $query = $res->query($domain,'NS');
    die "DNS query NS for $domain failed" unless $query;
    my @ns;
    for my $rr ( $query->answer ) {
	next unless $rr->type eq 'NS';
	push(@ns,$rr->rdatastr);
    }
    die "Found no nameservers for $domain" unless @ns;
    $res->nameservers(@ns);
    my @zone = $res->axfr($domain);
    die "Zonetransfer $domain failed" unless @zone;
    for my $rr ( @zone ) {
	next unless $rr->type eq 'CNAME';
	my $name = $rr->name;
	$name =~ s/\..*$//;
	my $server = $rr->rdatastr;
	$server =~ s/\.$//;
	push(@{$alias{$server}},$name);
    }
    # sort aliases
    for my $h ( keys %alias ) {
	@{$alias{$h}} = sort @{$alias{$h}};
    }
}
