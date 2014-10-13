# JBoss parameters
class jboss::params {
  case $::osfamily {
    'RedHat': {
      $staging_folder = '/opt/staging'
      $owner = 'jboss'
      $group = 'jboss'
      $standalone_conf = 'standalone.conf.sh'
      $service_name = 'jboss'
      $target = '/opt/jboss'
    }
    'Windows': {
      $staging_folder = regsubst($::staging_windir, '\\', '/', 'G')
      $owner = 'S-1-5-32-544' # Adminstrators
      $group = 'S-1-5-18'     # SYSTEM
      $standalone_conf = 'standalone.conf.bat'
      $service_name = 'JBOSS_EAP_SERVICE'
      $target = 'C:/jboss'
    }
    default: {
      fail("JBoss module does not support ${::osfamily}")
    }
  }
}
