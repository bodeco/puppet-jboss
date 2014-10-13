# module: JBoss for Windows:
class jboss (
  $version            = '6.2.0',
  $url                = 'puppet:///modules/jboss',
  $target             = $jboss::params::target,
  $java_xms           = '1536m',
  $java_xmx           = '1536m',
  $java_max_perm_size = '256m',
  $java_options       = '', # Additional options such as -DBASE_SABRIX_DIRECTORY
) inherits jboss::params {

  include 'jboss::install'
  $path = $jboss::install::folder
  include 'jboss::config'
  include 'jboss::service'

  Class['jboss::install'] -> Class['jboss::config'] ~> Class['::jboss::service']
}
