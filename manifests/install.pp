# JBoss installation
class jboss::install {
  $url = $jboss::url
  $version = $jboss::version
  $target = $jboss::target

  $parse_ver = split($version, '[.]')
  $major_ver = $parse_ver[0]
  $minor_ver = $parse_ver[1]
  $micro_ver = $parse_ver[2]

  package { '7zip':
    ensure   => present,
    provider => chocolatey,
  }

  package { 'java.jdk':
    ensure   => present,
    provider => chocolatey,
  }

  $file = "jboss-eap-${version}.zip"
  $source = "${url}/${file}"

  staging::file { $file:
    source => $source,
  }

  $staging_folder = regsubst($::staging_windir, '\\', '/', 'G')
  $filepath = "${staging_folder}/jboss/${file}"
  $folder = "${target}/jboss-eap-${major_ver}.${minor_ver}"

  exec { 'extract_jboss':
    command   => "\"C:/Program Files/7-zip/7z.exe\" x ${filepath}",
    cwd       => $target,
    logoutput => true,
    creates   => $folder,
    require   => [
      File[$target],
      Package['7zip'],
      Staging::File[$file],
    ],
  }

  # see: http://www.mastertheboss.com/jboss-eap/installing-jboss-eap-6-as-a-service
  $sbin_path = "${folder}/modules/native/sbin"

  File {
    owner => 'S-1-5-32-544', # Adminstrators
    group => 'S-1-5-18',     # SYSTEM
  }

  file { $target:
    ensure => 'directory',
  }

  file { [
    "${folder}/modules/native",
    "${folder}/modules/native/sbin",
  ]:
    ensure  => directory,
    require => Exec['extract_jboss'],
  }

  file { "${sbin_path}/prunsrv.exe":
    source => 'puppet:///modules/jboss/prunsrv.exe',
    mode   => '0755',
    before => Exec['install_service'],
  }

  file { "${sbin_path}/commons-daemons-1.0.15.jar":
    source => 'puppet:///modules/jboss/commons-daemon-1.0.15.jar',
    before => Exec['install_service'],
  }

  file { "${sbin_path}/service.bat":
    source  => 'puppet:///modules/jboss/service.bat',
    mode    => '0755',
    before  => Exec['install_service'],
  }

  file { "${sbin_path}/service.conf.bat":
    content => template('jboss/service.conf.bat.erb'),
    mode    => '0755',
    before  => Exec['install_service'],
  }

  exec { 'install_service':
    command     => "${sbin_path}/service.bat install",
    environment => 'JAVA_HOME=C:/Program Files/Java/jdk1.7.0_60',
    refreshonly => true,
    logoutput   => true,
    require     => Package['java.jdk'],
    subscribe   => File["${sbin_path}/service.bat", "${sbin_path}/service.conf.bat"]
  }
}
