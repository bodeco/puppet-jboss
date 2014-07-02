# JBoss jar files
define jboss::jar (
  $source,
) {
  file { "${jboss::path}/standalone/deployments/${name}":
    source             => $source,
    source_permissions => ignore,
    require            => Class['jboss::install'],
    notify             => Class['jboss::service'],
  }
}
