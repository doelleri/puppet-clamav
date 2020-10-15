# clamonacc.pp
# Set up clamonacc service.
#

class clamav::clamonacc {

  file { 'clamav-clamonacc.service':
    ensure  => file,
    path    => '/etc/systemd/system/clamav-clamonacc.service',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/clamav-clamonacc.service.erb"),
  }

  exec { 'clamonacc systemctl daemon-reload':
    command     => 'systemctl daemon-reload',
    path        => ['/bin', '/usr/bin'],
    subscribe   => File['clamav-clamonacc.service'],
    refreshonly => true,
  }

  service { 'clamonacc':
    ensure     => $clamav::clamonacc_service_ensure,
    name       => $clamav::clamonacc_service,
    enable     => $clamav::clamonacc_service_enable,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => [Package['clamd'], File['clamd.conf']],
  }
}
