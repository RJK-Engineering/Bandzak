#~ crossings, per direction a dead end flag
#~ loop
#~      if crossing:
#~          look for exit without dead end flag: turn and go there
#~          else, if no exit without dead en flag:
#~              return to previous crossing, set flag for just visited direction, face opposite direction
#~      if no exit (dead end):
#~              return to previous crossing, set flag for just visited direction, face opposite direction
#~      if no crossing: go to exit

#~ strategy: list of directions to consider, permutation of (left, forward, right)


my $crossings = [[]];
my $facingDirection; # u/d/l/r
my $map = <<EOF;
┌┬─┐
├┼─┤
││ │
└┴─┘
╔╦═╗
╠╬═╣
║║ ║
╚╩═╝
EOF
# ord()
#~ 226 148 140 226 148 172 226 148 128 226 148 144
#~ 226 148 156 226 148 188 226 148 128 226 148 164
#~ 226 148 130 226 148 130          32 226 148 130
#~ 226 148 148 226 148 180 226 148 128 226 148 152

#~ 226 149 148 226 149 166 226 149 144 226 149 151
#~ 226 149 160 226 149 172 226 149 144 226 149 163
#~ 226 149 145 226 149 145          32 226 149 145
#~ 226 149 154 226 149 169 226 149 144 226 149 157

my $start = [0,0];

my %a;
foreach (split //, $map) {
    if (chomp) {
        print "\n";
        next;
    }
    print " ", ord($_);
}
#~ print ((join "\n", sort keys %a), "\n");


