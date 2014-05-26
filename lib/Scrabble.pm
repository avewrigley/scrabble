package Scrabble;

# ABSTRACT: simple scrabble tools

use File::Slurp;
use Template;

use Log::Any qw( $log );
use Log::Dispatch;
use Log::Dispatch::FileRotate;
use Log::Any::Adapter;

use strict;
use warnings;

my %value = (
    A => 1,
    B => 3,
    C => 3,
    D => 2,
    E => 1,
    F => 4,
    G => 2,
    H => 4,
    I => 1,
    J => 8,
    K => 5,
    L => 1,
    M => 3,
    N => 1,
    O => 1,
    P => 3,
    Q => 10,
    R => 1,
    S => 1,
    T => 1,
    U => 1,
    V => 4,
    W => 4,
    X => 8,
    Y => 4,
    Z => 10,
);

my $logfile = '/var/log/scrabble/scrabble.log';

my $dispatcher = Log::Dispatch->new(
    callbacks  => sub {
        my %args = @_;
        my $message = $args{message};
        return "$$: " . uc( $args{level} ) . ": " . scalar( localtime ) . ": $message";
    }
);

Log::Any::Adapter->set( 'Dispatch', dispatcher => $dispatcher );

$dispatcher->add(
    my $file = Log::Dispatch::FileRotate->new(
        name            => 'logfile',
        min_level       => 'debug',
        filename        => $logfile,
        mode            => 'append' ,
        DatePattern     => 'yyyy-MM-dd',
        max             => 7,
        newline         => 1,
    ),
);

sub new
{
    my $class = shift;
    my %args = @_;
    my $self = bless \%args, $class;
    $self->{type} ||= 'p';
    my @words = read_file( $self->{word_file} );
    $log->debug( "load word list from $self->{word_file}" );
    $self->{words_list} = \@words;
    $log->debug( scalar( @{$self->{words_list}} ) . " words loaded" );
    chomp( @{$self->{words_list}} );
    %{$self->{words_hash}} = map { $_ => 1 } @{$self->{words_list}};
    $log->debug( "type: $self->{type}" ) if $self->{type};
    $log->debug( "word: $self->{word}" ) if $self->{word};
    return $self;
}

sub regex
{
    my $self = shift;
    my $regex = $self->{word};
    my @words = grep s/($regex)/uc($1)/e, @{$self->{words_list}};
    return sort { length( $a ) <=> length( $b ) } @words;
}

sub permute
{
    my $self = shift;

    my $permutee = $self->{word};
    return unless $permutee;
    my $c1 = join '', sort split //, $permutee;
    my @words;
    for my $word (  @{$self->{words_list}} )
    {
        my $c2 = join '.*', sort split //, $word;
        push( @words, $word ) if $c1 =~ /$c2/;
    }
    return sort { length( $b ) <=> length( $a ) } @words;
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
    return sort { length( $a ) <=> length( $b ) } @words;
}

sub words
{
    my $self = shift;
    $log->debug( "get words" );
    unless ( $self->{type} )
    {
        warn "no type";
        return;
    }
    my @words;
    if ( $self->{type} eq 'r' ) # regex
    {
        @words = $self->regex();
    }
    elsif ( $self->{type} eq 'p' ) # permute
    {
        @words = $self->permute();
    }
    elsif ( $self->{type} eq 'a' ) # anagram
    {
        @words = $self->anagram();
    }
    else
    {
        warn "unknown type $self->{type}";
    }
    @words = map { w => $_, l => length( $_ ), v => calculate_value( $_ ) }, @words;
    $log->debug( scalar( @words ), " words found - ", join( ",", map $_->{w},  @words ) );
    return @words;
}

sub render_html
{
    my $self = shift;
    my @words = @_;
    my $template = Template->new( { ABSOLUTE => 1 } );
    my $output = '';
    $template->process( $self->{template_file}, { %$self, words => \@words }, \$output ) || die $template->error();
    return join( '', $output );
}

sub calculate_value
{
    my $word = shift;
    my $value = 0;
    my @letters = split //, $word;
    for my $letter ( @letters )
    {
        $value += $value{uc $letter};
    }
    return $value;
}
