use strict;
use warnings;

use Win32::Console;

my $STDOUT = new Win32::Console(STD_OUTPUT_HANDLE);
# $STDOUT->OutputCP(437);
# my $STDIN  = new Win32::Console(STD_INPUT_HANDLE);

# http://mewbies.com/geek_fun_files/ascii/ascii_art_light_scale_and_gray_scale_chart.htm
# my $gradient = '$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,"^`\'.';
my $gradient = '$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?<>i!lI;:"^+~-_,`\'.';

my @gradient = split //, $gradient;
my $gradientLevels = @gradient;

my $rows = 20;
my @gradients;

for (0..$rows) {
    my $level = int (($gradientLevels-1) / $rows * $_);
    push @gradients, $gradient[$level];
    print $gradient[$level] x 80, "\n";
}

pop @gradients;
for (reverse @gradients) {
    print $_ x 80, "\n";
}


