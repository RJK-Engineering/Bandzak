use strict;
use warnings;

use RJK::TotalCmd::Settings::Ini;

my $ini = new RJK::TotalCmd::Settings::Ini()->read;

use Data::Dump;
dd $ini->getColors();
