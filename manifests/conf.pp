# JBoss configuration files
define jboss::conf (
  $source  = undef,
  $content = undef,
) {

  file { "${jboss::path}/${name}":
    source             => $source,
    content            => $content,
    source_permissions => ignore,
    notify             => Class['jboss::service'],
  }
}
