# This class installs core python packages.  This should only be used by
# including the 'python' class.
#
# @example
#   include python::install
#
class python::install {

  $python = $::python::version ? {
    'system' => 'python',
    'pypy'   => 'pypy',
    default  => "python${python::version}",
  }

  $python_dev = python::dev_name()
  $dev_ensure = $python::dev ? {
    true    => present,
    default => absent,
  }

  $pip_ensure = $python::pip ? {
    true    => present,
    default => absent,
  }

  $python_virtualenv = python::virtualenv_name()
  $virtualenv_ensure = $python::virtualenv ? {
    true    => present,
    default => absent,
  }

  if $python_virtualenv {
    if $::osfamily == 'FreeBSD' and $::python::version =~ /^3/ {
      package { $python_virtualenv:
        ensure   => $virtualenv_ensure,
        provider => 'pip',
      }
    } else {
      package { $python_virtualenv: ensure => $virtualenv_ensure }
    }
  }

  if $python_dev {
    package { $python_dev: ensure => $dev_ensure }
  }

  if $python::use_epel == true {
    include 'epel'
    Class['epel'] -> Package[$python]
  }

  python::ensure_pip($pip_ensure)

  package { $python: ensure => present }
}
