# JBOss configuration
class jboss::config {
  $folder = $jboss::path
  $java_xms = $jboss::java_xms
  $java_xmx = $jboss::java_xmx
  $java_max_perm_size = $jboss::java_max_perm_size
  $java_options = $jboss::java_options

  file { "${folder}/bin/standalone.conf.bat":
    content => template('jboss/standalone.conf.bat.erb'),
  }
}
