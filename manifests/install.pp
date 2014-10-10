# JBoss installation
class jboss::install {
  $url = $jboss::url
  $version = $jboss::version
  $target = $jboss::target

  $parse_ver = split($version, '[.]')
  $major_ver = $parse_ver[0]
  $minor_ver = $parse_ver[1]
  $micro_ver = $parse_ver[2]

  include 'archive::staging'

  package { 'java.jdk':
    ensure   => present,
    provider => chocolatey,
  }

  $file = "jboss-eap-${version}.zip"
  $source = "${url}/${file}"

  $staging_folder = regsubst($::staging_windir, '\\', '/', 'G')
  $folder = "${target}/jboss-eap-${major_ver}.${minor_ver}"

  file { $target:
    ensure => 'directory',
    owner  => 'S-1-5-32-544', # Adminstrators
    group  => 'S-1-5-18',     # SYSTEM
    mode   => '0644',
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
