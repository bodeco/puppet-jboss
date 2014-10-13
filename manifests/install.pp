# JBoss installation
class jboss::install inherits jboss::params {
  $url = $jboss::url
  $version = $jboss::version
  $target = $jboss::target

  $parse_ver = split($version, '[.]')
  $major_ver = $parse_ver[0]
  $minor_ver = $parse_ver[1]
  $micro_ver = $parse_ver[2]

  include 'archive::staging'

  case $::osfamily {
    'RedHat': {
      require 'java'
    }
    'Windows': {
      package { 'java.jdk':
        ensure   => present,
        provider => chocolatey,
      }
      include 'jboss::install::windows'
      Class['jboss::install'] -> Class['jboss::install::windows'] -> Class['jboss::config']
    }
  }

  $file = "jboss-eap-${version}.zip"
  $source = "${url}/${file}"

  $staging_folder = $jboss::params::staging_folder
  $folder = "${target}/jboss-eap-${major_ver}.${minor_ver}"

  file { $target:
    ensure => directory,
    owner  => $jboss::params::owner,
    group  => $jboss::params::group,
    mode   => '0755',
  }

  archive { $file:
    path         => "${staging_folder}/${file}",
    source       => $source,
    extract      => true,
    extract_path => $target,
    creates      => $folder,
    cleanup      => true,
    require      => File[$target],
  }

}
