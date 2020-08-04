use strict;
use warnings;

# https://perldoc.perl.org/Encode.html
use Encode qw(encode_utf8);

# https://perldoc.perl.org/Win32.html
use Win32;

# Unicode
#~ Win32::SetConsoleOutputCP(65001);
# or
# https://metacpan.org/pod/Win32::Console
#~ use Win32::Console;
#~ Win32::Console::OutputCP(65001);

# remove warning "Wide character in print"
binmode(STDOUT, ":utf8");

# io functions return short names
my $dir = '.';
opendir my $dh, $dir or die "$!";
my @files;

# Win32::GetLongPathName changes drive letter to upper case!
$dir = ucfirst $dir;

while (my $file = readdir $dh) {
    # short name, path may be relative!
    my $path = "$dir\\$file";
    # convert to long
    my $long = Win32::GetLongPathName($path);
    # path contains "longname components" if converted is not equal to short
    if ($long ne $path) {
        # https://en.wikipedia.org/wiki/ASCII
        # replace all but printable ascii chars
        my $clean = $long =~ s/[^\x20-\x7E]/_/gr;
        push @files, "short: $path\nlong:  $long\nclean: $clean";
    } else {
        my $clean = $path;
        if ($clean =~ s/[^\x20-\x7E]/_/g) {
            # chars 0x80-0xFF are converted to their multi-byte utf-8 counterparts
            my $encoded = encode_utf8 $path;
            push @files, "short: $path\nclean: $clean\nencdd: $encoded";
        }
    }
}
close $dh;

print join("\n", @files), "\n";

open my $fh, ">:utf8", "test~" or die "$!";
print $fh join("\n", @files), "\n";
close $fh;
