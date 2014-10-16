# install Windows service
class jboss::install::windows {
  $version = $jboss::install::version
  $target    = $jboss::install::target
  $major_ver = $jboss::install::major_ver
  $minor_ver = $jboss::install::minor_ver
  $micro_ver = $jboss::install::micro_ver

  $java_xms = $jboss::java_xms
  $java_xmx = $jboss::java_xmx
  $java_max_perm_size = $jboss::java_max_perm_size
  $java_options = $jboss::java_options

  # see: http://www.mastertheboss.com/jboss-eap/installing-jboss-eap-6-as-a-service
  $folder = "${target}/jboss-eap-${major_ver}.${minor_ver}"
  $native_path = "${folder}/modules/native"
  $sbin_path = "${native_path}/sbin"

  File {
    owner => 'S-1-5-32-544', # Adminstrators
    group => 'S-1-5-18',     # SYSTEM
    mode  => '0644',
  }

  file { [
    $native_path,
    $sbin_path,
  ]:
    ensure  => directory,
  }

  file { "${sbin_path}/prunsrv.exe":
    source => 'puppet:///modules/jboss/prunsrv.exe',
    mode   => '0755',
  }

  file { "${sbin_path}/commons-daemons-1.0.15.jar":
    source => 'puppet:///modules/jboss/commons-daemon-1.0.15.jar',
  }

  file { "${sbin_path}/service.bat":
    source => 'puppet:///modules/jboss/service.bat',
    mode   => '0755',
  }

  file { "${sbin_path}/service.conf.bat":
    content => template('jboss/service.conf.bat.erb'),
    mode    => '0755',
  }

  exec { 'install_service':
    command     => "${sbin_path}/service.bat install",
    environment => 'JAVA_HOME=C:/Program Files/Java/jdk1.7.0_60',
    refreshonly => true,
    logoutput   => true,
    subscribe   => File[
      "${sbin_path}/prunsrv.exe",
      "${sbin_path}/commons-daemons-1.0.15.jar",
      "${sbin_path}/service.bat",
      "${sbin_path}/service.conf.bat"
    ],
  }
}
