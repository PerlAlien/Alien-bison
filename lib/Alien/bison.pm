package Alien::bison;

use strict;
use warnings;
use 5.008001;
use base qw( Alien::Base );

# ABSTRACT: Find or build bison, the parser generator
# VERSION

=head1 SYNOPSIS

From a Perl script

 use Alien::bison;
 use Env qw( @PATH );
 unshift @PATH, Alien::bison->bin_dir;
 system 'bison', ...;

From L<alienfile>:

 use alienfile;
 
 share {
   ..
   requires 'Alien::bison' => 0;
   build [ '%{bison} ...' ];
   ...
 };

From Build.PL for L<Alien::Base::ModuleBuild>:

 use Alien:Base::ModuleBuild;
 my $builder = Module::Build->new(
   ...
   alien_bin_requires => [ 'Alien::bison' ],
   ...
 );
 $builder->create_build_script;

=head1 DESCRIPTION

This package can be used by other CPAN modules that require bison,
the GNU Parser generator based on YACC.

=head1 HELPERS

=head2 bison

 %{bison}

Returns the name of the bison command.  Usually just C<bison>.

=cut

sub alien_helper
{
  return {
    bison => sub { 'bison' },
  };
}

1;

=head1 SEE ALSO

=over 4

=item L<Alien>

=item L<Alien::flex>

=back
