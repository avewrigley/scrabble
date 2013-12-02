package Scrabble;

# ABSTRACT: simple scrabble tools

use File::Slurp;
use Algorithm::Permute;
use Plack::Request;
use strict;
use warnings;

sub new
{
    my $class = shift;
    my %args = @_;
    my $self = bless \%args, $class;
    @{$self->{words_list}} = read_file( "english.txt" );
    chomp( @{$self->{words_list}} );
    %{$self->{words_hash}} = map { $_ => 1 } @{$self->{words_list}};
    return $self;
}

sub regex
{
    my $self = shift;
    my $regex = $self->{word};
    my @words = grep s/($regex)/uc($1)/e, @{$self->{words_list}};
    return grep length( $_ ) eq $self->{length}, @words if $self->{length};
}

sub substring
{
    my $self = shift;
    my $substring = $self->{word};
    my @words = grep s/($substring)/uc($1)/e, @{$self->{words_list}};
    return grep length( $_ ) eq $self->{length}, @words if $self->{length};
}

sub permute
{
    my $self = shift;
    my $permutee = $self->{word};
    my @letters = split //, $permutee;
    my $length = $self->{length} || scalar @letters;
    my $p = new Algorithm::Permute( \@letters, $length );
    return unless $p;
    my %done;
    my @words;
    while ( my $word = join( '', $p->next ) ) 
    {
        push( @words, $word ) if $self->{words_hash}{$word} && ! $done{$word}++;
    }
    return @words;
}

sub anagram
{
    my $self = shift;
    my $anagram = $self->{word};
    my @letters = split( //, $anagram );
    my @words = @{$self->{words_list}};
    for my $letter ( @letters )
    {
        @words = grep s/($letter)/uc($1)/e, @words;
    }
    return grep length( $_ ) eq $self->{length}, @words if $self->{length};
}

sub words
{
    my $self = shift;
    warn "type: $self->{type}";
    return unless $self->{type};
    if ( $self->{type} eq 'r' ) # regex
    {
        return $self->regex();
    }
    elsif ( $self->{type} eq 's' ) # substring
    {
        return $self->substring();
    }
    elsif ( $self->{type} eq 'p' ) # permute
    {
        return $self->permute();
    }
    elsif ( $self->{type} eq 'a' ) # anagram
    {
        return $self->anagram();
    }
}

sub psgi_app
{
    my $self = shift;

    return sub {
        my $req = Plack::Request->new( shift );
        $self->{type} = $req->param( 't' );
        $self->{length} = $req->param( 'l' );
        $self->{word} = $req->param( 'w' );
        my $code = 200;
        my $res = $req->new_response( $code );
        $res->content_type( "text/html" );
        my $body = <<EOF;
<form>
<table>
    <tr>
        <th>Type</th>
        <td>
            <select name="t" />
                <option value="p">Permute</option>
                <option value="r">Regex</option>
                <option value="a">Anagram</option>
                <option value="s">Substring</option>
            </select>
        </td>
    </tr>
    <tr>
        <th>Word</th>
        <td>
            <input name="w" value="$self->{word}" />
        </td>
    </tr>
    <tr>
        <th>Length</th>
        <td>
            <input name="l" value="$self->{length}" />
        </td>
    </tr>
    <tr>
        <th></th>
        <td>
            <input type="submit" />
        </td>
    </tr>
</table>
</form>
<script>
document.form[0];
</script>
EOF
        my @words = $self->words();
        $body .= "<pre>" . join( "\n", @words ) . "</pre>" if @words;
        $res->body( "<body>$body</body>" );
        return $res->finalize;
    };
}

1;
