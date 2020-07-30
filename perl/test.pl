use strict;
use warnings;

use v5.10.1;

my $var = "abc";
my $abc = 0;
for ($var) {
    when ("ab") { $abc = 1 }
    when ("abc") { $abc = 2 }
}

die $abc;