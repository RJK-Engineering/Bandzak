use strict;
use warnings;

my $args = 'media.bitrate > 123 & "media.duration (time)" <= 45 & tc.hidden = 0 & tc.creationdate > "\"" & tc.name !cont.(case) "" & tc.creationdate > "a b c"';

my @args =
    map { s/^"//r =~ s/"$//r =~ s/\0/"/r }  # remove surrounding quotes, restore in-string quotes
    $args =~ s/\\"/\0/gr                    # replace escaped in-string quotes with null chars
    =~ /(".*?"|\S+)/g;                      # match quoted strings and non-space sequences

use Data::Dump;
dd \@args;
