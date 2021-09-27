#! /usr/bin/perl

# Run command in all branches

use strict;
use warnings;
use 5.016;
use Git;
use Error qw(:try);
use Getopt::Long;

my %opts;
GetOptions(\%opts,'q') || die;

my @cmd = @ARGV;
say join(' / ',@cmd) if @cmd;

my $repo = Git->repository;

# The current branch (to return to)
my $curbranch = $repo->command_oneline('symbolic-ref','--short','-q','HEAD');

# List branches, put current branch first.
my @branches = ( $curbranch );
for ( $repo->command('show-ref','--heads') ) {
    if ( m<refs/heads/(\S+)$> ) {
	push(@branches,$1) unless ( $1 eq $curbranch );
    }
}

say "@branches";

for my $br ( @branches ) {
    say "*** $br ***";

    my $remote = $repo->config("branch.$br.remote");
    my $refs = defined $remote ? $repo->remote_refs($remote,['heads']) : {};

    # Checkout branch unless it's already current.
    unless ( $repo->command_oneline('symbolic-ref','--short','-q','HEAD') eq "$br" ) {
	$repo->command_noisy('checkout','-q',$br);
    }
    next unless ( @cmd );

    my($cmd,@args) = @cmd;
    if ( $cmd eq 'git' || $cmd eq 'g' ) {
	if ( @args == 1 && $args[0] eq 'pull' ) {
	    # The branch must exist on the remote
	    next unless ( exists $refs->{"refs/heads/$br"} );
	}
	if ( exists $opts{q} ) {
	    # Be quiet about errors in the command
	    try {
		$repo->command_noisy('--no-pager',@args);
	    }
	    catch Git::Error::Command with {
	    }
	}
	else {
	    $repo->command_noisy('--no-pager',@args);
	}
    }
    else {
	system(@cmd);
    }
    print "\n";
}

# Check out the branch we where on when we started
unless ( $repo->command_oneline('symbolic-ref','--short','-q','HEAD') eq "$curbranch" ) {
    $repo->command_noisy('checkout','-q',$curbranch);
}
