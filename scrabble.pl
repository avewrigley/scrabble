#!/usr/bin/env perl
#set filetype=perl

use strict;
use warnings;

use lib 'lib';
use FindBin qw( $Bin );
use Scrabble;

my $type = shift;
my $word = shift;
my $length = shift;
my $word_file = "$Bin/words.txt";

die "option must be one of (r|s|p|a)" unless defined $type and $type =~ /^(r|s|p|a)$/;

my $scrabble = new Scrabble( word_file => $word_file, length => $length, type => $type, word => $word );
my @words = $scrabble->words();
print map "$_->{w} $_->{l} $_->{v}\n", @words;
