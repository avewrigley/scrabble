#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';
use Scrabble;

my $type = shift;
my $word = shift;
my $length = shift;

die "option must be one of (r|s|p|a)" unless defined $type and $type =~ /^(r|s|p|a)$/;

my $scrabble = new Scrabble( length => $length, type => $type, word => $word );
my @words = $scrabble->words();
print map "$_\n", @words;
