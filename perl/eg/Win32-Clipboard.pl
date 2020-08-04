use strict;
use warnings;

use Win32::Clipboard;

my $clip = Win32::Clipboard();
my $text = $clip->GetText();
my $unic = $clip->GetAs(CF_UNICODETEXT);

print "text: ", $text, "\n";
print "unic: ", $unic, "\n";

use Encode qw(decode);
use Win32;
Win32::SetConsoleOutputCP(65001);
# disable warning "Wide character in print"
binmode(STDOUT, ":utf8");

print "dcdd: ", decode("UTF16-LE", $unic), "\n";

#~ $clip->WaitForChange();
#~ print "Clipboard has changed!\n";
