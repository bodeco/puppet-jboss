define jboss::conf (
  $source  = undef,
  $content = undef,
) {

  file { "${jboss::path}/${name}":
    source  => $source,
    content => $content,
    notify  => Class['jboss::service'],
  }
}
