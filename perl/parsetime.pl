
my $time = "2005-1-3 3:0:8";
print "$time\n";
my @t = split /[-: ]/, $time;

print "Date::Parse\n";
use Date::Parse ();
$time = Date::Parse::str2time(sprintf "%u:%02u:%02uT%02u:%02u:%02u", @t);
print format_datetime($time), "\t$time\n";

use Time::Local;
$t[0] -= 1900;
$t[1]--;

print "Time::Local timelocal\n";
$time = timelocal( reverse @t );
print format_datetime($time), "\t$time\n";

print "Time::Local timegm\n";
$time = timegm( reverse @t );
print format_datetime($time), "\t$time\n";

sub format_datetime {
    my @t = localtime shift;
    return (sprintf("%s-%s-%s %s:%s:%s", $t[5]+1900, $t[4]+1, $t[3], $t[2], $t[1], $t[0]));
}
