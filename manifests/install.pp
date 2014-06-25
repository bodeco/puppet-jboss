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

  file { $target:
    ensure => 'directory',
  }

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

  file { [
    "${folder}/modules/native",
    "${folder}/modules/native/sbin",
  ]:
    ensure => directory,
    require => Exec['extract_jboss'],
  }

  file { "${sbin_path}/prunsrv.exe":
    source             => 'puppet:///modules/jboss/prunsrv.exe',
    mode               => '755',
    source_permissions => ignore,
    before             => Exec['install_service'],
  }

  file { "${sbin_path}/commons-daemons-1.0.15.jar":
    source             => 'puppet:///modules/jboss/commons-daemon-1.0.15.jar',
    source_permissions => ignore,
    before             => Exec['install_service'],
  }

  file { "${sbin_path}/service.bat":
    source             => 'puppet:///modules/jboss/service.bat',
    mode               => '755',
    source_permissions => ignore,
    before             => Exec['install_service'],
  }

  file { "${sbin_path}/service.conf.bat":
    #source             => 'puppet:///modules/jboss/service.conf.bat',
    content => template('jboss/service.conf.bat.erb'),
    mode               => '755',
    source_permissions => ignore,
    before             => Exec['install_service'],
  }

  exec { 'install_service':
    command     => "${sbin_path}/service.bat install",
    refreshonly => true,
    logoutput   => true,
    subscribe   => File["${sbin_path}/service.bat", "${sbin_path}/service.conf.bat"]
  }
}
