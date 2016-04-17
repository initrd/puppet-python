function python::virtualenv_name() {
  case $facts['kernel'] {
    'Linux': {
      $python_virtualenv = $facts['lsbdistcodename'] ? {
        'jessie' => 'virtualenv',
        default  => 'python-virtualenv',
      }
    }
    'FreeBSD': {
      if $::python::version =~ /^3/ {
        $python_virtualenv = 'virtualenv'
      } else {
        $python_virtualenv = 'py27-virtualenv'
      }
    }
  }
}
