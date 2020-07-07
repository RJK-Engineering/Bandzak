use strict;
use warnings;

my $digits = <<EOF;
 _     _  _     _  _  _  _  _
| |  | _| _||_||_ |_   ||_||_|
|_|  ||_  _|  | _||_|  ||_| _|
EOF

my ($w, $h) = (3, 3);
my $re = "." x $w;

my $data = [];
my $n = 0;

foreach my $l (split /\n/, $digits) {
    my @d = map { sprintf "%-$w.${w}s", $_ } grep { /./ } split /($re)/, $l;
    $data->[$n++] = \@d;
}

printnr(9876543210);

sub printnr {
    my $nr = shift;
    my @digits = split //, $nr;
    print "@digits\n";
    foreach my $l (0..$w-1) {
        foreach my $d (@digits) {
            print $data->[$l][$d];
        }
        print "\n";
    }
}
