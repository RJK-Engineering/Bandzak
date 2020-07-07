use strict;
use warnings;

sub f {
    $_ = 4;
    f2();
}
sub f_local {
    local $_ = 4;
    f2();
}
sub f2 {
    print "value in f2 = $_\n";
}
my @a = qw(1 2);
foreach (@a) {
    my $v = $_;
    f_local();
    print "$v == $_\n";
}
foreach (@a) {
    my $v = $_;
    f();
    print "$v != $_\n";
}
