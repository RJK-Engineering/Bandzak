use strict;
use warnings;

use RJK::TotalCmd::Settings::Ini;

my $ini = new RJK::TotalCmd::Settings::Ini()->read;

my @colors = $ini->getColors();

foreach (@colors) {
    my $c = $_->{Color};

    my $b = int $c / 2**16;
    $c -= $b * 2**16;
    my $g = int $c / 2**8;
    $c -= $g * 2**8;
    my $r = $c;

    $_->{r} = $r;
    $_->{g} = $g;
    $_->{b} = $b;
}
#~  0  8   C   F
#~  0  8  12  15

#~ 00 55  AA  FF
#~  0 85 170 255
#~   42 127 212

sub getVgaVal {
    my $c = shift;
    if ($c < 42) {
        return 0;
    } elsif ($c < 127) {
        return 85;
    } elsif ($c < 212) {
        return 170;
    }
    return 255;
}

sub getVgaValues {
    my ($orig, $r, $g, $b) = @_;
    $r = getVgaVal($r);
    $g = getVgaVal($g);
    $b = getVgaVal($b);

    # if all diff
    # 0AF -> 0AA middle = A
    # 05F -> 55F middle = 5
    # 05A -> 55A middle = 5
    # 5AF -> 5AA middle = A
    # set F to A if middle = A
    #  or 0 to 5 if middle = 5
    if ($r != $g && $g != $b) {
        if ($r == 255 && ($g == 170 || $b == 170)) {
            $r = 170;
        } elsif ($g == 255 && ($r == 170 || $b == 170)) {
            $g = 170;
        } elsif ($b == 255 && ($r == 170 || $g == 170)) {
            $b = 170;
        } elsif ($r == 0 && ($g == 85 || $b == 85)) {
            $r = 85;
        } elsif ($g == 0 && ($r == 85 || $b == 85)) {
            $g = 85;
        } elsif ($b == 0 && ($r == 85 || $g == 85)) {
            $b = 85;
        }
    }

    # special case AA0 (yellow) -> A50 (orange/brown)
    if ($r == 170 && $g == 170 && $b == 0) {
        $g = 85;
    }

    my $ok = (
        ($r == $g || $r == $b || $b == $g) &&
        !($r == 170 && $g == 170 && $b == 0)
    ) || ($r == 170 && $g == 85 && $b == 0);
    if (!$ok) {
        die "$r $g $b";
    }
    return ($r, $g, $b);
}

my $printCompletePage = 0;
#~ $printCompletePage = 1;

if ($printCompletePage) {
    print "<html><head><title>dircolors</title>\n";
    print '<style type="text/css">h1,td{color:#FFF} td{width:200px} body{background-color:#000}</style>';
    print "\n</head><body>\n";
}
print "\n<table>\n";
foreach (@colors) {
    printf "<tr><td>%s</td>", $_->{Search} =~ s/>//r;
    printf "<td bgcolor=\"#%02X%02X%02X\"></td>", $_->{r}, $_->{g}, $_->{b};
    printf "<td bgcolor=\"#%02X%02X%02X\"></td>", getVgaValues($_, $_->{r}, $_->{g}, $_->{b});
    print "</tr>\n",

}
print "</table>\n";
print "\n</body>\n" if $printCompletePage;
