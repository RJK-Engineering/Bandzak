use strict;
use warnings;

use Win32::Console;
my $STDOUT = new Win32::Console(STD_OUTPUT_HANDLE);
$STDOUT->OutputCP(437);

use RJK::Console::TextCanvas;
#~ print (chr($_),"\n") for 179..218; exit;
#~ print ($_, chr($_),"\n") for 179..218; exit;

#~ my $html = <<EOT;
#~ <table class="double">
#~     <tr><td></td><td></td></tr>
#~     <tr><td></td><td></td></tr>
#~ </table>
#~ EOT

# s: single
# d: double
# o: overwrite double lines with single lines
# f: fuse single lines (do not replace single lines with double lines)

my $boxes = [
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

    [(12,0), (0,0), "s"],
    [(13,0), (1,0), "s"],
    [(12,1), (0,1), "s"],
    [(13,1), (1,1), "s"],

    [( 0,5), (20,1), "s"],
    [(21,5), (20,1), "d"],
    [(31,5), ( 4,1), "d"],
    [(10,6), (15,1), "s"],
];

for (1..50) {
    my $x = 1 + int rand 60;
    my $y = 1 + int rand 20;
    my $w = 1 + int rand 20;
    my $h = 1 + int rand 4;
    push @$boxes, [($x,$y), ($w,$h), "f"];
}
#~ my $canvas = new RJK::Console::TextCanvas(43, 4);
#~ my $canvas = new RJK::Console::TextCanvas(80, 10);
my $canvas = new RJK::Console::TextCanvas(80, 25);
foreach my $box (@$boxes) {
    $canvas->box(@$box);
}
#~ for (1..22) {
    $canvas->draw();
#~     sleep 1;
#~ }
#~ $canvas->iterate(sub {
#~     my ($line, $char, $bitArray) = @_;
#~     print "$line $char $bitArray\n";
#~ });

