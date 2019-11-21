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


my $scrabble = new Scrabble( word_file => $word_file, length => $length, type => $type, word => $word );
my @words = $scrabble->words();
print map "$_->{w} $_->{l} $_->{v}\n", @words;
