# Alien::bison ![static](https://github.com/PerlAlien/Alien-bison/workflows/static/badge.svg) ![linux](https://github.com/PerlAlien/Alien-bison/workflows/linux/badge.svg) ![macos](https://github.com/PerlAlien/Alien-bison/workflows/macos/badge.svg) ![windows](https://github.com/PerlAlien/Alien-bison/workflows/windows/badge.svg)

Find or build bison, the parser generator

# SYNOPSIS

From a Perl script

```perl
use Alien::bison;
use Env qw( @PATH );
unshift @PATH, Alien::bison->bin_dir;
system 'bison', ...;
```

From [alienfile](https://metacpan.org/pod/alienfile):

```perl
use alienfile;

share {
  ..
  requires 'Alien::bison' => 0;
  build [ '%{bison} ...' ];
  ...
};
```

From Build.PL for [Alien::Base::ModuleBuild](https://metacpan.org/pod/Alien::Base::ModuleBuild):

```perl
use Alien:Base::ModuleBuild;
my $builder = Module::Build->new(
  ...
  alien_bin_requires => [ 'Alien::bison' ],
  ...
);
$builder->create_build_script;
```

# DESCRIPTION

This package can be used by other CPAN modules that require bison,
the GNU Parser generator based on YACC.

# HELPERS

## bison

```
%{bison}
```

Returns the name of the bison command.  Usually just `bison`.

# SEE ALSO

- [Alien](https://metacpan.org/pod/Alien)
- [Alien::flex](https://metacpan.org/pod/Alien::flex)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
