use Plack::Request;
use Scrabble;

use strict;
use warnings;

sub {
    my $req = Plack::Request->new( shift );
    my $code = 200;
    my $type = $req->param( 't' );
    my $word = $req->param( 'w' );
    my $res = $req->new_response( $code );
    $res->content_type( "text/html" );
    return $res->finalize unless $req->path eq '/';
    my $scrabble = Scrabble->new( type => $type, word => $word );
    my $body = $scrabble->render_html( $scrabble->words );
    $res->body( "<body>$body</body>" );
    return $res->finalize;
}
