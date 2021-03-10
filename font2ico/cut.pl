use strict;
use warnings;

my %opts = (
    iconWidth => 16,
    iconHeight => 16,

    #~ gridWidth => 2,
    #~ gridHeight => 2,
    gridWidth => 8,
    gridHeight => 28,
    gridPaddingLeft => 0,
    gridPaddingTop => 0,

    # font-size: 11pt
    #~ cellWidth => 22,
    #~ cellHeight => 17,
    #~ cellPaddingLeft => 3,
    #~ cellPaddingRight => 3,
    #~ cellPaddingTop => 0,
    #~ cellPaddingBottom => 1,

    # font-size: 12pt
    #~ cellWidth => 24,
    #~ cellHeight => 18,
    #~ cellPaddingLeft => 4,
    #~ cellPaddingRight => 4,
    #~ cellPaddingTop => 0,
    #~ cellPaddingBottom => 2,

    # font-size: 13pt
    #~ cellWidth => 26,
    #~ cellHeight => 21,
    #~ cellPaddingLeft => 5,
    #~ cellPaddingRight => 5,
    #~ cellPaddingTop => 2,
    #~ cellPaddingBottom => 3,

    # font-size: 14pt
    cellWidth => 27,
    cellHeight => 22,
    cellPaddingLeft => 6,
    cellPaddingRight => 5,
    cellPaddingTop => 2,
    cellPaddingBottom => 4,

    # font-size: 96pt
    #~ cellWidth => 185, # wingdings
    #~ cellWidth => 166, # webdings
    #~ cellHeight => 147,
    #~ cellPaddingLeft => 33,
    #~ cellPaddingRight => 32,
    #~ cellPaddingTop => 12,
    #~ cellPaddingBottom => 15,
);


$opts{input} = shift || die;
$opts{outputDir} = shift || ".";
-d $opts{outputDir} || die "No such dir: $opts{outputDir}";

my $w = $opts{cellWidth} - $opts{cellPaddingLeft} - $opts{cellPaddingRight};
my $h = $opts{cellHeight} - $opts{cellPaddingTop} - $opts{cellPaddingBottom};

print "Input size: $w,$h\n";

use Time::HiRes ();

for (    my $y=$opts{gridPaddingTop}  + $opts{cellPaddingTop};  $y<$opts{cellHeight}*$opts{gridHeight}; $y+=$opts{cellHeight}) {
    for (my $x=$opts{gridPaddingLeft} + $opts{cellPaddingLeft}; $x<$opts{cellWidth} *$opts{gridWidth};  $x+=$opts{cellWidth}) {
        print "$x,$y\t";
        system "i_view",
            $opts{input},
            "/crop=($x,$y,$w,$h)",
            #~ "/resize=($opts{iconWidth}, $opts{iconHeight})",
            #~ "/resample",
            sprintf("/convert=$opts{outputDir}\\%04u,%04u.ico", $x, $y);
    }
    print "\n";
}
