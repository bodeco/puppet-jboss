# JBOss configuration
class jboss::config inherits jboss::params {
  $jboss_path = $jboss::path
  $java_xms = $jboss::java_xms
  $java_xmx = $jboss::java_xmx
  $java_max_perm_size = $jboss::java_max_perm_size
  $java_options = $jboss::java_options
  $conf = $jboss::params::standalone_conf

  file { "${jboss_path}/bin/${conf}":
    content => template("jboss/${conf}.erb"),
  }
}
