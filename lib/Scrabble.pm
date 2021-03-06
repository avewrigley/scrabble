package Scrabble;

# ABSTRACT: simple scrabble tools

use File::Slurp;
use Template;
use FindBin qw( $Bin );

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

sub new
{
    my $class = shift;
    my %args = @_;
    my $self = bless \%args, $class;
    $self->{type} ||= 'p';
    $self->{word} = lc( $self->{word} );
    my @words = map lc($_), read_file( $self->{word_file} );
    $self->{words_list} = [ map lc( $_ ), @words ];
    chomp( @{$self->{words_list}} );
    return $self;
}

sub regex
{
    my $self = shift;
    my $regex = $self->{word};
    my @words = grep s/($regex)/uc($1)/e, @{$self->{words_list}};
    my @sorted = sort { length( $a ) <=> length( $b ) } @words;
    return @sorted;
}

sub permute
{
    my $self = shift;

    my $permutee = $self->{word};
    return unless $permutee;
    my $c1 = join '', map $_ . '?', sort split //, $permutee;
    my @words;
    for my $word ( @{$self->{words_list}} )
    {
        my $c2 = join '', sort split //, $word;
        if ( $c2 =~ /^$c1$/ )
        {
            push( @words, $word ) 
        }
    }
    my @sorted = sort { length( $b ) <=> length( $a ) } @words;
    return @sorted;
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
    my @sorted = sort { length( $a ) <=> length( $b ) } @words;
    return @sorted;
}

sub words
{
    my $self = shift;
    unless ( $self->{type} )
    {
        warn "no type";
        return;
    }
    my @words;
    if ( $self->{type} =~ /^r/ ) # regex
    {
        @words = $self->regex();
    }
    elsif ( $self->{type} =~ /^p/ ) # permute
    {
        @words = $self->permute();
    }
    elsif ( $self->{type} =~ /^a/ ) # anagram
    {
        @words = $self->anagram();
    }
    else
    {
        warn "unknown type $self->{type}";
    }
    @words = map { word => $_, len => length( $_ ), val => calculate_value( $_ ) }, @words;
    if ( exists $self->{limit} )
    {
        $#words = $self->{limit}-1 if $#words > $self->{limit}-1
    }
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
