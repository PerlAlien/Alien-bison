package My::ModuleBuild;

use strict;
use warnings;
use base qw( Alien::Base::ModuleBuild );
use File::chdir;
use Capture::Tiny qw( capture_stderr );
use File::Spec;

sub new
{
  my($class, %args) = @_;
  
  $args{alien_name} = 'bison';
  $args{alien_build_commands} = [
    '%c --prefix=%s',
    'make',
  ];
  $args{alien_install_commands} = [
    'make install',
  ];
  $args{alien_repository} = {
    protocol => 'http',
    host     => 'ftp.gnu.org',
    location => '/gnu/bison/',
    pattern  => qr{^bison-.*\.tar\.gz$},
  };
  
  my $self = $class->SUPER::new(%args);
  
  $self;
}

sub alien_check_installed_version
{
  my($self) = @_;

  my @paths = ([]);

  if($^O eq 'MSWin32')
  {
    eval '# line '. __LINE__ . ' "' . __FILE__ . "\n" . q{
      use strict;
      use warnings;
      use Win32API::Registry 0.21 qw( :ALL );
      
      my @uninstall_key_names = qw(
        software\wow6432node\microsoft\windows\currentversion\uninstall
        software\microsoft\windows\currentversion\uninstall
      );
      
      foreach my $uninstall_key_name (@uninstall_key_names)
      {
        my $uninstall_key;
        RegOpenKeyEx( HKEY_LOCAL_MACHINE, $uninstall_key_name, 0, KEY_READ, $uninstall_key ) || next;
        
        my $pos = 0;
        my($subkey, $class, $time) = ('','','');
        my($namSiz, $clsSiz) = (1024,1024);
        while(RegEnumKeyEx( $uninstall_key, $pos++, $subkey, $namSiz, [], $class, $clsSiz, $time))
        {
          next unless $subkey =~ /^bison/i;
          my $bison_key;
          RegOpenKeyEx( $uninstall_key, $subkey, 0, KEY_READ, $bison_key ) || next;
          
          my $data;
          if(RegQueryValueEx($bison_key, "InstallLocation", [], REG_SZ, $data, [] ))
          {
            push @paths, [File::Spec->catdir($data, "bin")];
          }
          
          RegCloseKey( $bison_key );
        }
        RegCloseKey($uninstall_key);
      }
    };
    warn $@ if $@;
    
    push @paths, map { [$ENV{$_}, qw( GnuWin32 bin )] } grep { defined $ENV{$_} } qw[ ProgramFiles ProgramFiles(x86) ];
  }
  
  print "try system paths:\n";
  print "  - ", $_, "\n" for map { $_ eq '' ? 'PATH' : $_ } map { File::Spec->catdir(@$_) } @paths;
  
  foreach my $path (@paths)
  {
    my @stdout;
    my $exe = File::Spec->catfile(@$path, 'bison');
    my $stderr = capture_stderr {
      @stdout = `$exe --version`;
    };
    if(defined $stdout[0] && $stdout[0] =~ /^bison/ && $stdout[0] =~ /([0-9\.]+)$/)
    {
      $self->config_data( bison_system_path => File::Spec->catdir(@$path) ) if @$path;
      return $1;
    }
  }
  return;
}

sub alien_check_built_version
{
  $CWD[-1] =~ /^bison-(.*)$/ ? $1 : 'unknown';
}

1;
