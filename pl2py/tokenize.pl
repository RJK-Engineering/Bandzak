use strict;
use warnings;

# http://www.softpanorama.org/Scripting/Pythonorama/Python_for_perl_programmers/Pl2py_reference/pl2py_functions_map.shtml
# https://wiki.python.org/moin/PerlPhrasebook
# book: Perl To Python Migration

use Perl::Tokenizer;

open my $fh, '<', $0 or die "$!";
local $/ = undef;
my $code = <$fh>;
close $fh;

Perl::Tokenizer::perl_tokens { print "@_\n" } $code;
