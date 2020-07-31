use strict;
use warnings;

use Perl::Tokenizer;

open my $fh, '<', $0 or die "$!";
local $/ = undef;
my $code = <$fh>;
close $fh;

Perl::Tokenizer::perl_tokens { print "@_\n" } $code;
