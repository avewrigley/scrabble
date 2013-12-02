use Scrabble;

use strict;
use warnings;

my $scrabble = Scrabble->new();
my $app = $scrabble->psgi_app();
