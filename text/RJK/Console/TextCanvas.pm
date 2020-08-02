package Console::TextCanvas;

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
    T_TOP => HORIZONTAL | TOP,
    T_LEFT => VERTICAL | LEFT,
    T_RIGHT => VERTICAL | RIGHT,
    T_BOTTOM => HORIZONTAL | BOTTOM,
    T_DOUBLE_TOP => DOUBLE_HORIZONTAL | DOUBLE_TOP,
    T_DOUBLE_LEFT => DOUBLE_VERTICAL | DOUBLE_LEFT,
    T_DOUBLE_RIGHT => DOUBLE_VERTICAL | DOUBLE_RIGHT,
    T_DOUBLE_BOTTOM => DOUBLE_HORIZONTAL | DOUBLE_BOTTOM,
};

sub new {
    my $self = bless {}, shift;
    $self->{width} = shift;
    $self->{height} = shift;

    my %cp437 = getCodePage437();
    my %cp437all = (%cp437, getUnavailable(\%cp437));
    #~ print join " ", sort {$a <=> $b} keys %cp437all; exit;
    #~ print join " ", grep {not exists $cp437all{$_}} 0..ALL_BITS_SET; exit;

    $self->{map} = [ map { exists $cp437all{$_} ? chr $cp437all{$_} : "?" } 0..ALL_BITS_SET ];

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
    my $self = shift;
    foreach my $y (@{$self->{canvas}}) {
        foreach my $x (@$y) {
            if (! defined $x) {
        print " '@$y'", "\n";
                print "!\n";
                next;
            }
            print $self->getChar($x);
            #~ print "$x ", $self->getChar($x), "\n" if $x;
        }
        print "\n";
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
    print "TOP " if $bitArray & TOP;
    print "LEFT " if $bitArray & LEFT;
    print "RIGHT " if $bitArray & RIGHT;
    print "BOTTOM " if $bitArray & BOTTOM;
    print "DOUBLE_TOP " if $bitArray & DOUBLE_TOP;
    print "DOUBLE_LEFT " if $bitArray & DOUBLE_LEFT;
    print "DOUBLE_RIGHT " if $bitArray & DOUBLE_RIGHT;
    print "DOUBLE_BOTTOM " if $bitArray & DOUBLE_BOTTOM;
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
        T_TOP, 193,
        T_LEFT, 180,
        T_RIGHT, 195,
        T_BOTTOM, 194,
        T_DOUBLE_LEFT, 185,
        T_DOUBLE_RIGHT, 204,
        T_DOUBLE_TOP, 202,
        T_DOUBLE_BOTTOM, 203,
    );
}

sub getUnavailable {
    my $cp = shift;
    return (
        0, 32,

        TOP, $cp->{0 | VERTICAL},
        BOTTOM, $cp->{0 | VERTICAL},
        DOUBLE_TOP, $cp->{0 | DOUBLE_VERTICAL},
        DOUBLE_BOTTOM, $cp->{0 | DOUBLE_VERTICAL},

        LEFT, $cp->{0 | HORIZONTAL},
        RIGHT, $cp->{0 | HORIZONTAL},
        DOUBLE_LEFT, $cp->{0 | DOUBLE_HORIZONTAL},
        DOUBLE_RIGHT, $cp->{0 | DOUBLE_HORIZONTAL},


        TOP | CORNER_DOUBLE_TOP_LEFT, $cp->{0 | CORNER_DOUBLE_TOP_LEFT},
        TOP | CORNER_DOUBLE_TOP_RIGHT, $cp->{0 | CORNER_DOUBLE_TOP_RIGHT},
        BOTTOM | CORNER_DOUBLE_BOTTOM_LEFT, $cp->{0 | CORNER_DOUBLE_BOTTOM_LEFT},
        BOTTOM | CORNER_DOUBLE_BOTTOM_RIGHT, $cp->{0 | CORNER_DOUBLE_BOTTOM_RIGHT},

        LEFT | CORNER_DOUBLE_TOP_LEFT, $cp->{0 | CORNER_DOUBLE_TOP_LEFT},
        RIGHT | CORNER_DOUBLE_TOP_RIGHT, $cp->{0 | CORNER_DOUBLE_TOP_RIGHT},
        LEFT | CORNER_DOUBLE_BOTTOM_LEFT, $cp->{0 | CORNER_DOUBLE_BOTTOM_LEFT},
        RIGHT | CORNER_DOUBLE_BOTTOM_RIGHT, $cp->{0 | CORNER_DOUBLE_BOTTOM_RIGHT},

        CORNER_TOP_LEFT | CORNER_DOUBLE_BOTTOM_RIGHT, $cp->{0 | CORNER_DOUBLE_BOTTOM_RIGHT},
        CORNER_TOP_RIGHT | CORNER_DOUBLE_BOTTOM_LEFT, $cp->{0 | CORNER_DOUBLE_BOTTOM_LEFT},
        CORNER_BOTTOM_LEFT | CORNER_DOUBLE_TOP_RIGHT, $cp->{0 | CORNER_DOUBLE_TOP_RIGHT},
        CORNER_BOTTOM_RIGHT | CORNER_DOUBLE_TOP_LEFT, $cp->{0 | CORNER_DOUBLE_TOP_LEFT},


        DOUBLE_TOP | CORNER_TOP_LEFT, $cp->{DOUBLE_TOP | RIGHT},
        DOUBLE_LEFT | CORNER_TOP_LEFT, $cp->{DOUBLE_LEFT | BOTTOM},
        CORNER_DOUBLE_BOTTOM_RIGHT | CORNER_TOP_LEFT, $cp->{0 | CORNER_DOUBLE_BOTTOM_RIGHT},

        DOUBLE_TOP | CORNER_TOP_RIGHT, $cp->{DOUBLE_TOP | LEFT},
        DOUBLE_RIGHT | CORNER_TOP_RIGHT, $cp->{DOUBLE_RIGHT | BOTTOM},
        CORNER_DOUBLE_BOTTOM_LEFT | CORNER_TOP_RIGHT, $cp->{0 | CORNER_DOUBLE_BOTTOM_LEFT},

        DOUBLE_BOTTOM | CORNER_BOTTOM_LEFT, $cp->{DOUBLE_BOTTOM | RIGHT},
        DOUBLE_LEFT | CORNER_BOTTOM_LEFT, $cp->{DOUBLE_LEFT | TOP},
        CORNER_DOUBLE_TOP_RIGHT | CORNER_BOTTOM_LEFT, $cp->{0 | CORNER_DOUBLE_TOP_RIGHT},

        DOUBLE_BOTTOM | CORNER_BOTTOM_RIGHT, $cp->{DOUBLE_BOTTOM | LEFT},
        DOUBLE_RIGHT | CORNER_BOTTOM_RIGHT, $cp->{DOUBLE_RIGHT | TOP},
        CORNER_DOUBLE_TOP_LEFT | CORNER_BOTTOM_RIGHT, $cp->{0 | CORNER_DOUBLE_TOP_LEFT},

        T_TOP | DOUBLE_BOTTOM, $cp->{HORIZONTAL | DOUBLE_BOTTOM},
        T_LEFT | DOUBLE_RIGHT, $cp->{VERTICAL | DOUBLE_RIGHT},
        T_RIGHT | DOUBLE_LEFT, $cp->{VERTICAL | DOUBLE_LEFT},
        T_BOTTOM | DOUBLE_TOP, $cp->{HORIZONTAL | DOUBLE_TOP},

        T_DOUBLE_TOP | BOTTOM, $cp->{0 | T_DOUBLE_TOP},
        T_DOUBLE_LEFT | RIGHT, $cp->{0 | T_DOUBLE_LEFT},
        T_DOUBLE_RIGHT | LEFT, $cp->{0 | T_DOUBLE_RIGHT},
        T_DOUBLE_BOTTOM | TOP, $cp->{0 | T_DOUBLE_BOTTOM},
    );
}

1;
