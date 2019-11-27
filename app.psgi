use Plack::Request;
use FindBin qw( $Bin );

use lib "$Bin/lib";
use Scrabble;

use strict;
use warnings;

my $word_file = "$Bin/words.txt";
my $template_file = "$Bin/html.t";

sub {
    my $req = Plack::Request->new( shift );
    my $code = 200;
    my $type = $req->param( 'type' );
    my $word = $req->param( 'word' );
    my $res = $req->new_response( $code );
    $res->content_type( "text/html" );
    return $res->finalize unless $req->path eq '/';
    my $scrabble = Scrabble->new( word_file => $word_file, template_file => $template_file, type => $type, word => $word );
    my $body = $scrabble->render_html( $scrabble->words );
    $res->body( "<body>$body</body>" );
    return $res->finalize;
}
