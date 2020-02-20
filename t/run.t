use strict;
use warnings;
use Test::Stream -V1;
use Test::Alien;
use Alien::bison;

plan 4;

alien_ok 'Alien::bison';
my $run = run_ok(['bison', '--version'])
  ->exit_is(0);

$run->success ? $run->note : $run->diag;

