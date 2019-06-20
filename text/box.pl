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

#~ print LEFT | TOP | DOUBLE_TOP, "\n";
#~ print LEFT | TOP | DOUBLE_LEFT, "\n";
#~ print RIGHT | TOP | DOUBLE_TOP, "\n";
#~ print RIGHT | TOP | DOUBLE_RIGHT, "\n";
#~ print RIGHT | BOTTOM | DOUBLE_RIGHT, "\n";
#~ print RIGHT | BOTTOM | DOUBLE_BOTTOM, "\n";
#~ print LEFT | RIGHT | TOP | BOTTOM | DOUBLE_TOP | DOUBLE_BOTTOM, "\n";
#~ print LEFT | RIGHT | TOP | BOTTOM | DOUBLE_LEFT | DOUBLE_RIGHT, "\n";

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

#~ getChar(TOP | RIGHT | BOTTOM  | LEFT | DOUBLE_HORIZONTAL);

#~ print (chr($_),"\n") for 179..218;
#~ print ($_, chr($_),"\n") for 179..218;
#~ exit;

my %cp437 = qw(
0 32

5 179
13 180
29 181
93 182
221 185
85 186
204 187
153 188
25 189
137 190
12 191
3 192
11 193
14 194
7 195
10 196
15 197
23 198
87 199
51 200
102 201
187 202
238 203
119 204
170 205
255 206
171 207
43 208
174 209
46 210
19 211
35 212
38 213
70 214
95 215
175 216
9 217
6 218
);

my %cp437missing = qw(
59 200
110 201
);

#~ my %cp437all = %cp437;
my %cp437all = (%cp437, %cp437missing);
#~ print join " ", sort {$a <=> $b} keys %cp437all; exit;
#~ print join " ", grep {not exists $cp437all{$_}} 0..(1<<8)-1; exit;

my @map = map { exists $cp437all{$_} ? chr($cp437all{$_}) : undef } 0..(1<<8)-1;

sub getChar {
    my $bitArray = shift;
    return $map[$bitArray] // "$bitArray ";
    #~ return $map[$bitArray] // charInfo($bitArray);
    #~ return charInfo($bitArray);
}

#~ my $box = new Console::TextBox();
my $html = <<EOT;
<table class="double">
    <tr><td></td><td></td></tr>
    <tr><td></td><td></td></tr>
</table>
EOT

my $table = {
    #~ border => [43, 4, "d"],
    border => [80, 24, "d"],
    boxes => [
        #~ [( 0,0), (0,0), "s"],
        #~ [( 1,0), (1,0), "f"],
        #~ [( 0,1), (0,1), "f"],
        #~ [( 1,1), (1,1), "f"],

        #~ [( 4,0), (0,0), "d"],
        #~ [( 5,0), (1,0), "d"],
        #~ [( 4,1), (0,1), "d"],
        #~ [( 5,1), (1,1), "d"],

        #~ [( 8,0), (2,2), "d"],
        #~ [( 8,0), (0,0), "s"],
        #~ [( 9,0), (1,0), "f"],
        #~ [( 8,1), (0,1), "f"],
        #~ [( 9,1), (1,1), "f"],

        #~ [(12,0), (0,0), "d"],
        #~ [(13,0), (1,0), "d"],
        #~ [(12,1), (0,1), "d"],
        #~ [(13,1), (1,1), "d"],
        #~ [(12,0), (2,2), "o"],

        [( 0,0), (20,1), "s"],
        [(21,0), (20,1), "d"],
        [(31,0), (4,1), "d"],
        [(10,1), (5,5), "s"],
    ],
};
for (1..10) {
    my $x = int rand 60;
    my $y = int rand 20;
    my $w = int rand 20;
    my $h = int rand 4;
    push @{$table->{boxes}}, [($x,$y), ($w,$h), "s"];
}

my $tWidth = $table->{border}[0];
my $tHeight = $table->{border}[1];
my $canvas = [];
push @$canvas, [ (0) x $tWidth ] for 1 .. $tHeight;

#~ print @$canvas, "\n";

foreach my $box (@{$table->{boxes}}) {
    my ($x, $y, $w, $h, $s, $f) = @$box;
    my $right = $x+$w+1;
    my $bottom = $y+$h+1;

    placeTopLeft($x, $y, $s, $f);
    placeHorizontal($x+1, $y, $w, $s, $f);
    placeTopRight($right, $y, $s, $f);

    placeVertical($x, $y+1, $w, $h, $s, $f);

    placeBottomLeft($x, $bottom, $s, $f);
    placeHorizontal($x+1, $bottom, $w, $s, $f);
    placeBottomRight($right, $bottom, $s, $f);
}

foreach my $y (@$canvas) {
    foreach my $x (@$y) {
        print getChar($x);
        #~ print "$x ", getChar($x), "\n" if $x;
    }
    print "\n";
}

sub placeTopLeft {
    my ($x, $y, $style, $fuse) = @_;
    update($x, $y, BOTTOM | RIGHT, $style, $fuse);
    #~ update($x, $y, ",");
}
sub placeTopRight {
    my ($x, $y, $style, $fuse) = @_;
    update($x, $y, BOTTOM | LEFT, $style, $fuse);
    #~ update($x, $y, "\\");
}

sub placeBottomLeft {
    my ($x, $y, $style, $fuse) = @_;
    update($x, $y, TOP | RIGHT, $style, $fuse);
    #~ update($x, $y, "\\");
}
sub placeBottomRight {
    my ($x, $y, $style, $fuse) = @_;
    update($x, $y, TOP | LEFT, $style, $fuse);
    #~ update($x, $y, ".");
}

sub placeHorizontal {
    my ($x, $y, $w, $style, $fuse) = @_;
    #~ update($x+$_, $y, "-") for 1..$w;
    update($x+$_, $y, LEFT | RIGHT, $style, $fuse) for 0..$w-1;
}
sub placeVertical {
    my ($x, $y, $w, $h, $style, $fuse) = @_;
    #~ update($x, $y+$_, "|") for 0..$h;
    #~ update($x+$w+2, $y+$_, "|") for 0..$h;
    update($x, $y+$_, TOP | BOTTOM, $style, $fuse) for 0..$h-1;
    update($x+$w+1, $y+$_, TOP | BOTTOM, $style, $fuse) for 0..$h-1;
}

sub update {
    my ($x, $y, $bitArray, $style, $fuse) = @_;
    if ($style) {
        if ($style eq 'd') {
            $bitArray |= DOUBLE_TOP if $bitArray & TOP;
            $bitArray |= DOUBLE_RIGHT if $bitArray & RIGHT;
            $bitArray |= DOUBLE_BOTTOM if $bitArray & BOTTOM;
            $bitArray |= DOUBLE_LEFT if $bitArray & LEFT;
        }
        if ($canvas->[$y][$x]) {
            if ($style eq 'o') {
                #~ print "$bitArray,";
                #~ $canvas->[$y][$x] &= (2**6-1 - DOUBLE_HORIZONTAL) if ! ($bitArray & DOUBLE_HORIZONTAL) && $bitArray & (LEFT | RIGHT) && $canvas->[$y][$x] & (LEFT | RIGHT);
                #~ $canvas->[$y][$x] &= (2**6-1 - DOUBLE_VERTICAL) if ! ($bitArray & DOUBLE_VERTICAL) && $bitArray & (TOP | BOTTOM) && $canvas->[$y][$x] & (TOP | BOTTOM);
                    #~ $canvas->[$y][$x] &= (2**6-1 - DOUBLE_HORIZONTAL) if $bitArray & (LEFT | RIGHT) && $canvas->[$y][$x] & (LEFT | RIGHT);
                    #~ $canvas->[$y][$x] &= (2**6-1 - DOUBLE_VERTICAL) if $bitArray & (TOP | BOTTOM) && $canvas->[$y][$x] & (TOP | BOTTOM);
                #~ print "$bitArray ";
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

__END__
╔╦═╗ double
╠╬═╣
║║ ║
╚╩═╝
s = single
d = double
n = none

print chr(179);
