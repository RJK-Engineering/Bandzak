
sub a { print join(', ', caller 0), "\n" }

  &a;
   a();
$a=a();
@a=a();

# output:
# main, (path), 1, main::a, , , , , 256, ,
# main, (path), 1, main::a, 1, , , , 256, ,
# main, (path), 1, main::a, 1, , , , 256, ,
# main, (path), 1, main::a, 1, 1, , , 256, ,
