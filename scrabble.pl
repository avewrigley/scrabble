#!/usr/bin/env perl
#set filetype=perl

use strict;
use warnings;

use lib 'lib';
use FindBin qw( $Bin );
use Scrabble;
use Getopt::Long;
use Text::Table;

my %opts = ( type => 'p' );
my @opts = qw( type=s verbose );
GetOptions( \%opts, @opts ) or pod2usage( verbose => 0 );

my $word = shift;
my $word_file = "$Bin/words.txt";

die "option must be one of ([r]egex|[p]ermute|[a]nagram)" unless defined $opts{type} and $opts{type} =~ /^(r|p|a)/;

my $scrabble = new Scrabble( word_file => $word_file, type => $opts{type}, word => $word );
my $tb = Text::Table->new( "Word", "Length", "Score" );

my $nwords = 0;
for my $word ( $scrabble->words() )
{
    $tb->add( $word->{word}, $word->{len}, $word->{val} );
    $nwords++;
}
print $tb;
print "\n$nwords results\n\n";
