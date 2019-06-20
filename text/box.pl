use strict;
use warnings;

use constant TOP => 1;
use constant RIGHT => 1 << 1;
use constant BOTTOM => 1 << 2;
use constant LEFT => 1 << 3;
use constant DOUBLE_TOP => 1 << 4;
use constant DOUBLE_RIGHT => 1 << 5;
use constant DOUBLE_BOTTOM => 1 << 6;
use constant DOUBLE_LEFT => 1 << 7;
use constant ALL_BITS_SET => 2**8 - 1;

#~ print (chr($_),"\n") for 179..218; exit;
#~ print ($_, chr($_),"\n") for 179..218; exit;
#~ permutations(); exit;

my %cp437 = getMapping();

#~ my %cp437all = %cp437;
#~ my %cp437all = (%cp437, %cp437missing);
#~ print join " ", sort {$a <=> $b} keys %cp437all; exit;
#~ print join " ", grep {not exists $cp437all{$_}} 0..ALL_BITS_SET; exit;

#~ my @map = map { exists $cp437{$_} ? chr $cp437{$_} : undef } 0..ALL_BITS_SET;
my @map = map { $cp437{$_} == $_ ? "$_ " : chr $cp437{$_} } 0..ALL_BITS_SET;

sub getChar {
    my $bitArray = shift;
    return $map[$bitArray];
    #~ return charInfo($bitArray);
}

#~ my $box = new Console::TextBox();
my $html = <<EOT;
<table class="double">
    <tr><td></td><td></td></tr>
    <tr><td></td><td></td></tr>
</table>
EOT

# s: single
# d: double
# o: overwrite double lines with single lines
# f: fuse single lines (do not replace a single line with double lines)

my $table = {
    border => [43, 4, "d"],
    #~ border => [80, 24, "d"],
    boxes => [
        [( 0,0), (0,0), "s"],
        [( 1,0), (1,0), "f"],
        [( 0,1), (0,1), "f"],
        [( 1,1), (1,1), "f"],

        [( 4,0), (0,0), "d"],
        [( 5,0), (1,0), "d"],
        [( 4,1), (0,1), "d"],
        [( 5,1), (1,1), "d"],

        [( 8,0), (2,2), "d"],
        [( 8,0), (0,0), "s"],
        [( 9,0), (1,0), "f"],
        [( 8,1), (0,1), "f"],
        [( 9,1), (1,1), "f"],

        [(12,0), (0,0), "d"],
        [(13,0), (1,0), "d"],
        [(12,1), (0,1), "d"],
        [(13,1), (1,1), "d"],
        [(12,0), (2,2), "o"],

        #~ [( 0,0), (20,1), "s"],
        #~ [(21,0), (20,1), "d"],
        #~ [(31,0), ( 4,1), "d"],
        #~ [(10,1), ( 5,5), "s"],
    ],
};
#~ for (1..10) {
#~     my $x = int rand 60;
#~     my $y = int rand 20;
#~     my $w = int rand 20;
#~     my $h = int rand 4;
#~     push @{$table->{boxes}}, [($x,$y), ($w,$h), "s"];
#~ }

my $tWidth = $table->{border}[0];
my $tHeight = $table->{border}[1];
my $canvas = [];
push @$canvas, [ (0) x $tWidth ] for 1 .. $tHeight;

#~ print @$canvas, "\n";

foreach my $box (@{$table->{boxes}}) {
    my ($x, $y, $w, $h, $s) = @$box;
    my $right = $x+$w+1;
    my $bottom = $y+$h+1;

    placeTopLeft($x, $y, $s);
    placeHorizontal($x+1, $y, $w, $s);
    placeTopRight($right, $y, $s);

    placeVertical($x, $y+1, $w, $h, $s);

    placeBottomLeft($x, $bottom, $s);
    placeHorizontal($x+1, $bottom, $w, $s);
    placeBottomRight($right, $bottom, $s);
}

foreach my $y (@$canvas) {
    foreach my $x (@$y) {
        print getChar($x);
        #~ print "$x ", getChar($x), "\n" if $x;
    }
    print "\n";
}

sub placeTopLeft {
    my ($x, $y, $style) = @_;
    update($x, $y, BOTTOM | RIGHT, $style);
}
sub placeTopRight {
    my ($x, $y, $style) = @_;
    update($x, $y, BOTTOM | LEFT, $style);
}

sub placeBottomLeft {
    my ($x, $y, $style) = @_;
    update($x, $y, TOP | RIGHT, $style);
}
sub placeBottomRight {
    my ($x, $y, $style) = @_;
    update($x, $y, TOP | LEFT, $style);
}

sub placeHorizontal {
    my ($x, $y, $w, $style) = @_;
    update($x+$_, $y, LEFT | RIGHT, $style) for 0..$w-1;
}
sub placeVertical {
    my ($x, $y, $w, $h, $style) = @_;
    update($x, $y+$_, TOP | BOTTOM, $style) for 0..$h-1;
    update($x+$w+1, $y+$_, TOP | BOTTOM, $style) for 0..$h-1;
}

sub update {
    my ($x, $y, $bitArray, $style) = @_;
    if ($style) {
        if ($style eq 'd') {
            $bitArray |= DOUBLE_TOP if $bitArray & TOP;
            $bitArray |= DOUBLE_RIGHT if $bitArray & RIGHT;
            $bitArray |= DOUBLE_BOTTOM if $bitArray & BOTTOM;
            $bitArray |= DOUBLE_LEFT if $bitArray & LEFT;
        }
        if ($canvas->[$y][$x]) {
            if ($style eq 'o') {
                $canvas->[$y][$x] &= (ALL_BITS_SET - DOUBLE_TOP) if $bitArray & TOP & $canvas->[$y][$x];
                $canvas->[$y][$x] &= (ALL_BITS_SET - DOUBLE_RIGHT) if $bitArray & RIGHT & $canvas->[$y][$x];
                $canvas->[$y][$x] &= (ALL_BITS_SET - DOUBLE_BOTTOM) if $bitArray & BOTTOM & $canvas->[$y][$x];
                $canvas->[$y][$x] &= (ALL_BITS_SET - DOUBLE_LEFT) if $bitArray & LEFT & $canvas->[$y][$x];
            } elsif ($style ne 'f') {
                $bitArray |= DOUBLE_TOP if $bitArray & TOP & $canvas->[$y][$x];
                $bitArray |= DOUBLE_RIGHT if $bitArray & RIGHT & $canvas->[$y][$x];
                $bitArray |= DOUBLE_BOTTOM if $bitArray & BOTTOM & $canvas->[$y][$x];
                $bitArray |= DOUBLE_LEFT if $bitArray & LEFT & $canvas->[$y][$x];
            }
        }
    }
    $canvas->[$y][$x] |= $bitArray;
}

sub permutations {
    for (0..ALL_BITS_SET) {
        my @parts;
        push @parts, "TOP" if $_ & TOP;
        push @parts, "LEFT" if $_ & LEFT;
        push @parts, "RIGHT" if $_ & RIGHT;
        push @parts, "BOTTOM" if $_ & BOTTOM;
        push @parts, "DOUBLE_TOP" if $_ & DOUBLE_TOP;
        push @parts, "DOUBLE_LEFT" if $_ & DOUBLE_LEFT;
        push @parts, "DOUBLE_RIGHT" if $_ & DOUBLE_RIGHT;
        push @parts, "DOUBLE_BOTTOM" if $_ & DOUBLE_BOTTOM;
        print join(" | ", @parts), ", $_,\n";
    }
}

sub charInfo {
    my $bitArray = shift;
    print "TOP " if $bitArray & TOP;
    print "RIGHT " if $bitArray & RIGHT;
    print "BOTTOM " if $bitArray & BOTTOM;
    print "LEFT " if $bitArray & LEFT;
    print "DOUBLE_TOP " if $bitArray & DOUBLE_TOP;
    print "DOUBLE_RIGHT " if $bitArray & DOUBLE_RIGHT;
    print "DOUBLE_BOTTOM " if $bitArray & DOUBLE_BOTTOM;
    print "DOUBLE_LEFT " if $bitArray & DOUBLE_LEFT;
}

sub getMapping {
    return (
        0, 32,
        TOP, 1,
        RIGHT, 2,
        TOP | RIGHT, 192,
        BOTTOM, 4,
        TOP | BOTTOM, 179,
        RIGHT | BOTTOM, 218,
        TOP | RIGHT | BOTTOM, 195,
        LEFT, 8,
        TOP | LEFT, 217,
        LEFT | RIGHT, 196,
        TOP | LEFT | RIGHT, 193,
        LEFT | BOTTOM, 191,
        TOP | LEFT | BOTTOM, 180,
        LEFT | RIGHT | BOTTOM, 194,
        TOP | LEFT | RIGHT | BOTTOM, 197,
        DOUBLE_TOP, 16,
        TOP | DOUBLE_TOP, 17,
        RIGHT | DOUBLE_TOP, 18,
        TOP | RIGHT | DOUBLE_TOP, 211,
        BOTTOM | DOUBLE_TOP, 20,
        TOP | BOTTOM | DOUBLE_TOP, 21,
        RIGHT | BOTTOM | DOUBLE_TOP, 22,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP, 198,
        LEFT | DOUBLE_TOP, 24,
        TOP | LEFT | DOUBLE_TOP, 189,
        LEFT | RIGHT | DOUBLE_TOP, 26,
        TOP | LEFT | RIGHT | DOUBLE_TOP, 208,
        LEFT | BOTTOM | DOUBLE_TOP, 28,
        TOP | LEFT | BOTTOM | DOUBLE_TOP, 181,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP, 30,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP, 31,
        DOUBLE_RIGHT, 32,
        TOP | DOUBLE_RIGHT, 33,
        RIGHT | DOUBLE_RIGHT, 34,
        TOP | RIGHT | DOUBLE_RIGHT, 212,
        BOTTOM | DOUBLE_RIGHT, 36,
        TOP | BOTTOM | DOUBLE_RIGHT, 37,
        RIGHT | BOTTOM | DOUBLE_RIGHT, 213,
        TOP | RIGHT | BOTTOM | DOUBLE_RIGHT, 198,
        LEFT | DOUBLE_RIGHT, 40,
        TOP | LEFT | DOUBLE_RIGHT, 41,
        LEFT | RIGHT | DOUBLE_RIGHT, 42,
        TOP | LEFT | RIGHT | DOUBLE_RIGHT, 208,
        LEFT | BOTTOM | DOUBLE_RIGHT, 44,
        TOP | LEFT | BOTTOM | DOUBLE_RIGHT, 45,
        LEFT | RIGHT | BOTTOM | DOUBLE_RIGHT, 210,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_RIGHT, 47,
        DOUBLE_TOP | DOUBLE_RIGHT, 48,
        TOP | DOUBLE_TOP | DOUBLE_RIGHT, 49,
        RIGHT | DOUBLE_TOP | DOUBLE_RIGHT, 50,
        TOP | RIGHT | DOUBLE_TOP | DOUBLE_RIGHT, 200,
        BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 52,
        TOP | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 53,
        RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 54,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 55,
        LEFT | DOUBLE_TOP | DOUBLE_RIGHT, 56,
        TOP | LEFT | DOUBLE_TOP | DOUBLE_RIGHT, 57,
        LEFT | RIGHT | DOUBLE_TOP | DOUBLE_RIGHT, 58,
        TOP | LEFT | RIGHT | DOUBLE_TOP | DOUBLE_RIGHT, 200,
        LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 60,
        TOP | LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 61,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 62,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT, 63,
        DOUBLE_BOTTOM, 64,
        TOP | DOUBLE_BOTTOM, 65,
        RIGHT | DOUBLE_BOTTOM, 66,
        TOP | RIGHT | DOUBLE_BOTTOM, 67,
        BOTTOM | DOUBLE_BOTTOM, 68,
        TOP | BOTTOM | DOUBLE_BOTTOM, 69,
        RIGHT | BOTTOM | DOUBLE_BOTTOM, 214,
        TOP | RIGHT | BOTTOM | DOUBLE_BOTTOM, 71,
        LEFT | DOUBLE_BOTTOM, 72,
        TOP | LEFT | DOUBLE_BOTTOM, 73,
        LEFT | RIGHT | DOUBLE_BOTTOM, 74,
        TOP | LEFT | RIGHT | DOUBLE_BOTTOM, 75,
        LEFT | BOTTOM | DOUBLE_BOTTOM, 76,
        TOP | LEFT | BOTTOM | DOUBLE_BOTTOM, 77,
        LEFT | RIGHT | BOTTOM | DOUBLE_BOTTOM, 210,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_BOTTOM, 79,
        DOUBLE_TOP | DOUBLE_BOTTOM, 80,
        TOP | DOUBLE_TOP | DOUBLE_BOTTOM, 81,
        RIGHT | DOUBLE_TOP | DOUBLE_BOTTOM, 82,
        TOP | RIGHT | DOUBLE_TOP | DOUBLE_BOTTOM, 83,
        BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 84,
        TOP | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 186,
        RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 86,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 199,
        LEFT | DOUBLE_TOP | DOUBLE_BOTTOM, 88,
        TOP | LEFT | DOUBLE_TOP | DOUBLE_BOTTOM, 89,
        LEFT | RIGHT | DOUBLE_TOP | DOUBLE_BOTTOM, 90,
        TOP | LEFT | RIGHT | DOUBLE_TOP | DOUBLE_BOTTOM, 91,
        LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 92,
        TOP | LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 182,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 94,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, 215,
        DOUBLE_RIGHT | DOUBLE_BOTTOM, 96,
        TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 97,
        RIGHT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 98,
        TOP | RIGHT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 99,
        BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 100,
        TOP | BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 101,
        RIGHT | BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 201,
        TOP | RIGHT | BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 103,
        LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 104,
        TOP | LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 105,
        LEFT | RIGHT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 106,
        TOP | LEFT | RIGHT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 107,
        LEFT | BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 108,
        TOP | LEFT | BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 109,
        LEFT | RIGHT | BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 201,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_RIGHT | DOUBLE_BOTTOM, 111,
        DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 112,
        TOP | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 113,
        RIGHT | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 114,
        TOP | RIGHT | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 115,
        BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 116,
        TOP | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 117,
        RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 118,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 204,
        LEFT | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 120,
        TOP | LEFT | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 121,
        LEFT | RIGHT | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 122,
        TOP | LEFT | RIGHT | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 123,
        LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 124,
        TOP | LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 125,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 126,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_RIGHT | DOUBLE_BOTTOM, 127,
        DOUBLE_LEFT, 128,
        TOP | DOUBLE_LEFT, 129,
        RIGHT | DOUBLE_LEFT, 130,
        TOP | RIGHT | DOUBLE_LEFT, 131,
        BOTTOM | DOUBLE_LEFT, 132,
        TOP | BOTTOM | DOUBLE_LEFT, 133,
        RIGHT | BOTTOM | DOUBLE_LEFT, 134,
        TOP | RIGHT | BOTTOM | DOUBLE_LEFT, 135,
        LEFT | DOUBLE_LEFT, 136,
        TOP | LEFT | DOUBLE_LEFT, 190,
        LEFT | RIGHT | DOUBLE_LEFT, 138,
        TOP | LEFT | RIGHT | DOUBLE_LEFT, 139,
        LEFT | BOTTOM | DOUBLE_LEFT, 140,
        TOP | LEFT | BOTTOM | DOUBLE_LEFT, 181,
        LEFT | RIGHT | BOTTOM | DOUBLE_LEFT, 142,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_LEFT, 143,
        DOUBLE_TOP | DOUBLE_LEFT, 144,
        TOP | DOUBLE_TOP | DOUBLE_LEFT, 145,
        RIGHT | DOUBLE_TOP | DOUBLE_LEFT, 146,
        TOP | RIGHT | DOUBLE_TOP | DOUBLE_LEFT, 147,
        BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 148,
        TOP | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 149,
        RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 150,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 151,
        LEFT | DOUBLE_TOP | DOUBLE_LEFT, 152,
        TOP | LEFT | DOUBLE_TOP | DOUBLE_LEFT, 188,
        LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT, 154,
        TOP | LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT, 155,
        LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 156,
        TOP | LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 157,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 158,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT, 159,
        DOUBLE_LEFT | DOUBLE_RIGHT, 160,
        TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 161,
        RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT, 162,
        TOP | RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT, 163,
        BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 164,
        TOP | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 165,
        RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 166,
        TOP | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 167,
        LEFT | DOUBLE_LEFT | DOUBLE_RIGHT, 168,
        TOP | LEFT | DOUBLE_LEFT | DOUBLE_RIGHT, 169,
        LEFT | RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT, 205,
        TOP | LEFT | RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT, 207,
        LEFT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 172,
        TOP | LEFT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 173,
        LEFT | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 209,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, 216,
        DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 176,
        TOP | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 177,
        RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 178,
        TOP | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 179,
        BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 180,
        TOP | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 181,
        RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 182,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 183,
        LEFT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 184,
        TOP | LEFT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 185,
        LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 186,
        TOP | LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 202,
        LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 188,
        TOP | LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 189,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 190,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT, 191,
        DOUBLE_LEFT | DOUBLE_BOTTOM, 192,
        TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 193,
        RIGHT | DOUBLE_LEFT | DOUBLE_BOTTOM, 194,
        TOP | RIGHT | DOUBLE_LEFT | DOUBLE_BOTTOM, 195,
        BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 196,
        TOP | BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 197,
        RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 198,
        TOP | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 199,
        LEFT | DOUBLE_LEFT | DOUBLE_BOTTOM, 200,
        TOP | LEFT | DOUBLE_LEFT | DOUBLE_BOTTOM, 201,
        LEFT | RIGHT | DOUBLE_LEFT | DOUBLE_BOTTOM, 202,
        TOP | LEFT | RIGHT | DOUBLE_LEFT | DOUBLE_BOTTOM, 203,
        LEFT | BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 187,
        TOP | LEFT | BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 205,
        LEFT | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 206,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_BOTTOM, 207,
        DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 208,
        TOP | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 209,
        RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 210,
        TOP | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 211,
        BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 212,
        TOP | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 213,
        RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 214,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 215,
        LEFT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 216,
        TOP | LEFT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 217,
        LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 218,
        TOP | LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 219,
        LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 220,
        TOP | LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 185,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 222,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_BOTTOM, 223,
        DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 224,
        TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 225,
        RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 226,
        TOP | RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 227,
        BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 228,
        TOP | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 229,
        RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 230,
        TOP | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 231,
        LEFT | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 232,
        TOP | LEFT | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 233,
        LEFT | RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 234,
        TOP | LEFT | RIGHT | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 235,
        LEFT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 236,
        TOP | LEFT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 237,
        LEFT | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 203,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 239,
        DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 240,
        TOP | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 241,
        RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 242,
        TOP | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 243,
        BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 244,
        TOP | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 245,
        RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 246,
        TOP | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 247,
        LEFT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 248,
        TOP | LEFT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 249,
        LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 250,
        TOP | LEFT | RIGHT | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 251,
        LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 252,
        TOP | LEFT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 253,
        LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 254,
        TOP | LEFT | RIGHT | BOTTOM | DOUBLE_TOP | DOUBLE_LEFT | DOUBLE_RIGHT | DOUBLE_BOTTOM, 206,
    );
}
