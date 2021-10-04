use strict;
use warnings;

use Win32::File;

my $file = shift;

open my $fh, '<', $file or die "$!: $file";

# clear read-only attribute
my $attrs;
Win32::File::GetAttributes ($file, $attrs) || die "$!: $file";
Win32::File::SetAttributes ($file, $attrs & !READONLY) || die "$!: $file";

# or simply clear all attributes
#~ Win32::File::SetAttributes ($file, 0) || die "$!: $file";

open $fh, '>>', $file or die "$!: $file";
print $fh "";
close $fh;

# set read-only attribute and restore previously set attributes
Win32::File::SetAttributes ($file, $attrs | READONLY) || die "$!: $file";

# or simply set read-only attribute and clear all other attributes
#~ Win32::File::SetAttributes ($file, READONLY) || die "$!: $file";
