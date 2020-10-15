# clamdscan.pp
# Set up clamdscan service and timer.
#

class clamav::clamdscan {

  file { 'clamav-clamdscan.service':
    ensure  => file,
    path    => '/etc/systemd/system/clamav-clamdscan.service',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/clamav-clamdscan.service.erb"),
  }

  file { 'clamav-clamdscan.timer':
    ensure  => file,
    path    => '/etc/systemd/system/clamav-clamdscan.timer',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/clamav-clamdscan.timer.erb"),
  }

  exec { 'clamdscan systemctl daemon-reload':
    command     => 'systemctl daemon-reload',
    path        => ['/bin', '/usr/bin'],
    subscribe   => [File['clamav-clamdscan.service'], File['clamav-clamdscan.timer']],
    refreshonly => true,
  }

  service { 'clamdscan.timer':
    ensure     => $clamav::clamdscan_timer_ensure,
    name       => $clamav::clamdscan_timer,
    enable     => $clamav::clamdscan_timer_enable,
    subscribe  => [Package['clamd'], File['clamd.conf']],
  }

  service { 'clamdscan':
    name       => $clamav::clamdscan_service,
    subscribe  => Service['clamdscan.timer'],
  }
}
