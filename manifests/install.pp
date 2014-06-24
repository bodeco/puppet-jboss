class jboss::install {
  $url = $jboss::url
  $version = $jboss::version
  $target = $jboss::target

  $parse_ver = split($version, '[.]')
  $major_ver = $parse_ver[0]
  $minor_ver = $parse_ver[1]

  package { '7zip':
    ensure   => present,
    provider => chocolatey,
  }

  package { 'javaruntime':
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
    require   => Staging::File[$file],
  }
}
