use strict;
use warnings;

use RJK::TotalCmd::Settings::Ini;

my %opts = (
    verbose => 0,
    colors => 'colors.txt',
);

my $ini = new RJK::TotalCmd::Settings::Ini()->read;
print "Loaded $ini->{path}\n";

my @colors = $ini->getColors;
use Data::Dump;
dd \@colors;

foreach (@colors) {
    print "$_->{nr} $_->{Color} $_->{Search}\n" if $opts{verbose};
}
print "Colors in INI file: " . scalar @colors . "\n";

my %searches = map { $_->{Search} => 1 } @colors;

my $i = 0;
open my $fh, '<', $opts{colors} or die "$!";
while (<$fh>) {
    my ($color, $hex) = /(\*?\w+)\s+#(\w{6})/;
    next unless $color;
    my $search = $color;
    $i++;
    printf "%s %s\n", $hex, $search if $opts{verbose};
    push @colors, { Color => hex($hex), Search => $search } unless $searches{$search};
}
close $fh;

print "Colors in $opts{colors}: $i\n";
$ini->setColors(\@colors);
$ini->write("a.ini");
exit;

print "Type \"ok\" to write INI ...\n";
my $r = <STDIN>;
chomp $r;
if ($r eq "ok") {
    $ini->setColors(\@colors);
    $ini->write;
    print "Written: $ini->{path}\n";
} else {
    print "Nothing written\n";
}
