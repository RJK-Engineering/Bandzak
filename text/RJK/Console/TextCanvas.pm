package RJK::Console::TextCanvas;

use strict;
use warnings;

use constant {
    TOP => 1,
    LEFT => 1 << 1,
    RIGHT => 1 << 2,
    BOTTOM => 1 << 3,
};
use constant {
    DOUBLE_TOP => 1 << 4 | TOP,
    DOUBLE_LEFT => 1 << 5 | LEFT,
    DOUBLE_RIGHT => 1 << 6 | RIGHT,
    DOUBLE_BOTTOM => 1 << 7 | BOTTOM,
    ALL_BITS_SET => 2**8 - 1,
};
use constant {
    VERTICAL => TOP | BOTTOM,
    HORIZONTAL => LEFT | RIGHT,
    DOUBLE_VERTICAL => DOUBLE_TOP | DOUBLE_BOTTOM,
    DOUBLE_HORIZONTAL => DOUBLE_LEFT | DOUBLE_RIGHT,
    NO_DOUBLE_TOP => ALL_BITS_SET - DOUBLE_TOP,
    NO_DOUBLE_LEFT => ALL_BITS_SET - DOUBLE_LEFT,
    NO_DOUBLE_RIGHT => ALL_BITS_SET - DOUBLE_RIGHT,
    NO_DOUBLE_BOTTOM => ALL_BITS_SET - DOUBLE_BOTTOM,
};
use constant {
    CORNER_TOP_LEFT => RIGHT | BOTTOM,
    CORNER_TOP_RIGHT => LEFT | BOTTOM,
    CORNER_BOTTOM_LEFT => TOP | RIGHT,
    CORNER_BOTTOM_RIGHT => TOP | LEFT,
    CORNER_DOUBLE_TOP_LEFT => DOUBLE_RIGHT | DOUBLE_BOTTOM,
    CORNER_DOUBLE_TOP_RIGHT => DOUBLE_LEFT | DOUBLE_BOTTOM,
    CORNER_DOUBLE_BOTTOM_LEFT => DOUBLE_TOP | DOUBLE_RIGHT,
    CORNER_DOUBLE_BOTTOM_RIGHT => DOUBLE_TOP | DOUBLE_LEFT,
};

sub new {
    my $self = bless {}, shift;
    $self->{width} = shift;
    $self->{height} = shift;

    my %chars = getCodePage437();
    #~ my %chars = getUnicode();
    getReplacements(\%chars);

    #~ print join " ", sort {$a <=> $b} keys %chars; exit;
    #~ print join " ", grep {not exists $chars{$_}} 0..ALL_BITS_SET; exit;

    $self->{map} = [ map { exists $chars{$_} ? chr $chars{$_} : "?" } 0..ALL_BITS_SET ];
    $self->{map}[0] = " ";

    $self->{canvas} = [];
    push @{$self->{canvas}}, [ (0) x $self->{width} ] for 1 .. $self->{height};

    return $self;
}

sub getChar {
    my ($self, $bitArray) = @_;
    return $self->{map}[$bitArray];
}

sub box {
    my ($self, $x, $y, $w, $h, $style) = @_;
    my $right = $x+$w+1;
    my $bottom = $y+$h+1;

    $self->update($x, $y, CORNER_TOP_LEFT, $style);
    $self->update($x+1+$_, $y, HORIZONTAL, $style) for 0..$w-1;
    $self->update($right, $y, CORNER_TOP_RIGHT, $style);

    $self->update($x, $y+1+$_, VERTICAL, $style) for 0..$h-1;
    $self->update($x+$w+1, $y+1+$_, VERTICAL, $style) for 0..$h-1;

    $self->update($x, $bottom, CORNER_BOTTOM_LEFT, $style);
    $self->update($x+1+$_, $bottom, HORIZONTAL, $style) for 0..$w-1;
    $self->update($right, $bottom, CORNER_BOTTOM_RIGHT, $style);
}

sub draw {
    my ($self, $console) = @_;

    my $write = $console ? sub { $console->Write(@_) } : sub { print @_ };

    foreach my $y (@{$self->{canvas}}) {
        foreach my $x (@$y) {
            if (! defined $x) {
        #~ $write->(" '@$y'", "\n");
        #~         $write->("!\n");
                next;
            }
            $write->($self->getChar($x));
            #~ $write->("$x ", $self->getChar($x), "\n") if $x;
        }
        $write->("\n");
    }
}

sub iterate {
    my ($self, $callback) = @_;
    my $line = 0;
    foreach my $row (@{$self->{canvas}}) {
        foreach my $bitArray (@$row) {
            $callback->($line, $self->getChar($bitArray), $bitArray);
        }
        $line++;
    }
}

sub update {
    my ($self, $x, $y, $bitArray, $style) = @_;
    if ($style) {
        if ($style eq 'd') {
            $bitArray |= DOUBLE_TOP if $bitArray & TOP;
            $bitArray |= DOUBLE_LEFT if $bitArray & LEFT;
            $bitArray |= DOUBLE_RIGHT if $bitArray & RIGHT;
            $bitArray |= DOUBLE_BOTTOM if $bitArray & BOTTOM;
        } elsif ($self->{canvas}[$y][$x]) {
            if ($style eq 'o') {
                $self->{canvas}[$y][$x] &= NO_DOUBLE_TOP if $bitArray & TOP;
                $self->{canvas}[$y][$x] &= NO_DOUBLE_LEFT if $bitArray & LEFT;
                $self->{canvas}[$y][$x] &= NO_DOUBLE_RIGHT if $bitArray & RIGHT;
                $self->{canvas}[$y][$x] &= NO_DOUBLE_BOTTOM if $bitArray & BOTTOM;
            } elsif ($style ne 'f') {
                $bitArray |= DOUBLE_TOP if $bitArray & TOP & $self->{canvas}[$y][$x];
                $bitArray |= DOUBLE_LEFT if $bitArray & LEFT & $self->{canvas}[$y][$x];
                $bitArray |= DOUBLE_RIGHT if $bitArray & RIGHT & $self->{canvas}[$y][$x];
                $bitArray |= DOUBLE_BOTTOM if $bitArray & BOTTOM & $self->{canvas}[$y][$x];
            }
        }
    }
    $self->{canvas}[$y][$x] |= $bitArray;
}

sub charInfo {
    my $bitArray = shift;
    return "TOP" if $bitArray & TOP;
    return "LEFT" if $bitArray & LEFT;
    return "RIGHT" if $bitArray & RIGHT;
    return "BOTTOM" if $bitArray & BOTTOM;
    return "DOUBLE_TOP" if $bitArray & DOUBLE_TOP;
    return "DOUBLE_LEFT" if $bitArray & DOUBLE_LEFT;
    return "DOUBLE_RIGHT" if $bitArray & DOUBLE_RIGHT;
    return "DOUBLE_BOTTOM" if $bitArray & DOUBLE_BOTTOM;
}

sub getCodePage437 {
    return (
        VERTICAL, 179,
        HORIZONTAL, 196,
        HORIZONTAL | VERTICAL, 197,
        VERTICAL | DOUBLE_LEFT, 181,
        VERTICAL | DOUBLE_RIGHT, 198,
        VERTICAL | DOUBLE_HORIZONTAL, 216,
        HORIZONTAL | DOUBLE_TOP, 208,
        HORIZONTAL | DOUBLE_BOTTOM, 210,
        HORIZONTAL | DOUBLE_VERTICAL, 215,
        TOP | DOUBLE_LEFT, 190,
        TOP | DOUBLE_RIGHT, 212,
        TOP | DOUBLE_HORIZONTAL, 207,
        LEFT | DOUBLE_TOP, 189,
        LEFT | DOUBLE_BOTTOM, 183,
        LEFT | DOUBLE_VERTICAL, 182,
        RIGHT | DOUBLE_TOP, 211,
        RIGHT | DOUBLE_BOTTOM, 214,
        RIGHT | DOUBLE_VERTICAL, 199,
        BOTTOM | DOUBLE_LEFT, 184,
        BOTTOM | DOUBLE_RIGHT, 213,
        BOTTOM | DOUBLE_HORIZONTAL, 209,
        CORNER_TOP_LEFT, 218,
        CORNER_TOP_RIGHT, 191,
        CORNER_BOTTOM_LEFT, 192,
        CORNER_BOTTOM_RIGHT, 217,
        CORNER_DOUBLE_TOP_LEFT, 201,
        CORNER_DOUBLE_TOP_RIGHT, 187,
        CORNER_DOUBLE_BOTTOM_LEFT, 200,
        CORNER_DOUBLE_BOTTOM_RIGHT, 188,
        DOUBLE_VERTICAL, 186,
        DOUBLE_HORIZONTAL, 205,
        DOUBLE_HORIZONTAL | DOUBLE_VERTICAL, 206,
        VERTICAL | LEFT, 180,
        VERTICAL | RIGHT, 195,
        HORIZONTAL | TOP, 193,
        HORIZONTAL | BOTTOM, 194,
        DOUBLE_VERTICAL | DOUBLE_LEFT, 185,
        DOUBLE_VERTICAL | DOUBLE_RIGHT, 204,
        DOUBLE_HORIZONTAL | DOUBLE_TOP, 202,
        DOUBLE_HORIZONTAL | DOUBLE_BOTTOM, 203,
    );
}

sub getUnicode {
    return (
        VERTICAL, 0x2502,
        HORIZONTAL, 0x2500,
        HORIZONTAL | VERTICAL, 0x253C,
        VERTICAL | DOUBLE_LEFT, 0x2561,
        VERTICAL | DOUBLE_RIGHT, 0x255E,
        VERTICAL | DOUBLE_HORIZONTAL, 0x256A,
        HORIZONTAL | DOUBLE_TOP, 0x2568,
        HORIZONTAL | DOUBLE_BOTTOM, 0x2565,
        HORIZONTAL | DOUBLE_VERTICAL, 0x256B,
        TOP | DOUBLE_LEFT, 0x255B,
        TOP | DOUBLE_RIGHT, 0x2558,
        TOP | DOUBLE_HORIZONTAL, 0x2567,
        LEFT | DOUBLE_TOP, 0x255C,
        LEFT | DOUBLE_BOTTOM, 0x2556,
        LEFT | DOUBLE_VERTICAL, 0x2562,
        RIGHT | DOUBLE_TOP, 0x2559,
        RIGHT | DOUBLE_BOTTOM, 0x2553,
        RIGHT | DOUBLE_VERTICAL, 0x255F,
        BOTTOM | DOUBLE_LEFT, 0x2555,
        BOTTOM | DOUBLE_RIGHT, 0x2552,
        BOTTOM | DOUBLE_HORIZONTAL, 0x2564,
        CORNER_TOP_LEFT, 0x250C,
        CORNER_TOP_RIGHT, 0x2510,
        CORNER_BOTTOM_LEFT, 0x2514,
        CORNER_BOTTOM_RIGHT, 0x2518,
        CORNER_DOUBLE_TOP_LEFT, 0x2554,
        CORNER_DOUBLE_TOP_RIGHT, 0x2557,
        CORNER_DOUBLE_BOTTOM_LEFT, 0x255A,
        CORNER_DOUBLE_BOTTOM_RIGHT, 0x255D,
        DOUBLE_VERTICAL, 0x2551,
        DOUBLE_HORIZONTAL, 0x2550,
        DOUBLE_HORIZONTAL | DOUBLE_VERTICAL, 0x256C,
        VERTICAL | LEFT, 0x2524,
        VERTICAL | RIGHT, 0x251C,
        HORIZONTAL | TOP, 0x2534,
        HORIZONTAL | BOTTOM, 0x252C,
        DOUBLE_VERTICAL | DOUBLE_LEFT, 0x2563,
        DOUBLE_VERTICAL | DOUBLE_RIGHT, 0x2560,
        DOUBLE_HORIZONTAL | DOUBLE_TOP, 0x2569,
        DOUBLE_HORIZONTAL | DOUBLE_BOTTOM, 0x2566,
        LEFT, 0x2574,
        RIGHT, 0x2576,
        TOP, 0x2575,
        BOTTOM, 0x2577,
    );
}

my %replacements = (
    TOP, VERTICAL,
    BOTTOM, VERTICAL,
    DOUBLE_TOP, DOUBLE_VERTICAL,
    DOUBLE_BOTTOM, DOUBLE_VERTICAL,

    LEFT, HORIZONTAL,
    RIGHT, HORIZONTAL,
    DOUBLE_LEFT, DOUBLE_HORIZONTAL,
    DOUBLE_RIGHT, DOUBLE_HORIZONTAL,

    TOP | CORNER_DOUBLE_TOP_LEFT, CORNER_DOUBLE_TOP_LEFT,
    TOP | CORNER_DOUBLE_TOP_RIGHT, CORNER_DOUBLE_TOP_RIGHT,
    BOTTOM | CORNER_DOUBLE_BOTTOM_LEFT, CORNER_DOUBLE_BOTTOM_LEFT,
    BOTTOM | CORNER_DOUBLE_BOTTOM_RIGHT, CORNER_DOUBLE_BOTTOM_RIGHT,

    LEFT | CORNER_DOUBLE_TOP_LEFT, CORNER_DOUBLE_TOP_LEFT,
    RIGHT | CORNER_DOUBLE_TOP_RIGHT, CORNER_DOUBLE_TOP_RIGHT,
    LEFT | CORNER_DOUBLE_BOTTOM_LEFT, CORNER_DOUBLE_BOTTOM_LEFT,
    RIGHT | CORNER_DOUBLE_BOTTOM_RIGHT, CORNER_DOUBLE_BOTTOM_RIGHT,

    CORNER_TOP_LEFT | CORNER_DOUBLE_BOTTOM_RIGHT, CORNER_DOUBLE_BOTTOM_RIGHT,
    CORNER_TOP_RIGHT | CORNER_DOUBLE_BOTTOM_LEFT, CORNER_DOUBLE_BOTTOM_LEFT,
    CORNER_BOTTOM_LEFT | CORNER_DOUBLE_TOP_RIGHT, CORNER_DOUBLE_TOP_RIGHT,
    CORNER_BOTTOM_RIGHT | CORNER_DOUBLE_TOP_LEFT, CORNER_DOUBLE_TOP_LEFT,

    DOUBLE_TOP | CORNER_TOP_LEFT, DOUBLE_TOP | RIGHT,
    DOUBLE_LEFT | CORNER_TOP_LEFT, DOUBLE_LEFT | BOTTOM,
    CORNER_DOUBLE_BOTTOM_RIGHT | CORNER_TOP_LEFT, CORNER_DOUBLE_BOTTOM_RIGHT,

    DOUBLE_TOP | CORNER_TOP_RIGHT, DOUBLE_TOP | LEFT,
    DOUBLE_RIGHT | CORNER_TOP_RIGHT, DOUBLE_RIGHT | BOTTOM,
    CORNER_DOUBLE_BOTTOM_LEFT | CORNER_TOP_RIGHT, CORNER_DOUBLE_BOTTOM_LEFT,

    DOUBLE_BOTTOM | CORNER_BOTTOM_LEFT, DOUBLE_BOTTOM | RIGHT,
    DOUBLE_LEFT | CORNER_BOTTOM_LEFT, DOUBLE_LEFT | TOP,
    CORNER_DOUBLE_TOP_RIGHT | CORNER_BOTTOM_LEFT, CORNER_DOUBLE_TOP_RIGHT,

    DOUBLE_BOTTOM | CORNER_BOTTOM_RIGHT, DOUBLE_BOTTOM | LEFT,
    DOUBLE_RIGHT | CORNER_BOTTOM_RIGHT, DOUBLE_RIGHT | TOP,
    CORNER_DOUBLE_TOP_LEFT | CORNER_BOTTOM_RIGHT, CORNER_DOUBLE_TOP_LEFT,

    DOUBLE_HORIZONTAL | DOUBLE_TOP | BOTTOM, DOUBLE_HORIZONTAL | DOUBLE_TOP,
    DOUBLE_HORIZONTAL | DOUBLE_BOTTOM | TOP, BOTTOM | DOUBLE_HORIZONTAL,
    DOUBLE_VERTICAL | DOUBLE_RIGHT | LEFT, DOUBLE_VERTICAL | DOUBLE_RIGHT,
    DOUBLE_VERTICAL | DOUBLE_LEFT | RIGHT, DOUBLE_VERTICAL | DOUBLE_LEFT,

    HORIZONTAL | TOP | DOUBLE_BOTTOM, HORIZONTAL | TOP,
    HORIZONTAL | BOTTOM | DOUBLE_TOP, HORIZONTAL | BOTTOM,
    VERTICAL | RIGHT | DOUBLE_LEFT, VERTICAL | RIGHT,
    VERTICAL | LEFT | DOUBLE_RIGHT, VERTICAL | LEFT,
);

sub getReplacements {
    my $cp = shift;
    foreach (keys %replacements) {
        $cp->{$_} //= $cp->{$replacements{$_}};
    }
}

1;
