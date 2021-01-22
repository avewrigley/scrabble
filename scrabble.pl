#!/usr/bin/env perl
#set filetype=perl

use strict;
use warnings;

use lib 'lib';
use FindBin qw( $Bin );
use Scrabble;
use Getopt::Long;
use Text::Table;
use Pod::Usage;

my %opts = ( limit => 40, type => 'p' );
my @opts = qw( type=s verbose anagram permute regex limit=i );
GetOptions( \%opts, @opts ) or pod2usage( verbose => 0 );

my $word = shift;
exit unless length($word);
my $word_file = "$Bin/words.txt";

my $type = $opts{type};
foreach my $k ( qw( regex permute anagram ) )
{
    $type = $k if $opts{$k};
}
die "option must be one of ([r]egex|[p]ermute|[a]nagram)" unless defined $type and $type =~ /^(r|p|a)/;

my $scrabble = new Scrabble( word_file => $word_file, type => $type, word => $word, limit => $opts{limit} );
my $tb = Text::Table->new( "Word", "Length", "Score" );

my $nwords = 0;
for my $word ( $scrabble->words() )
{
    $tb->add( $word->{word}, $word->{len}, $word->{val} );
    $nwords++;
}
print uc($type), "\n";
print $tb;
print "\n$nwords results\n\n";
