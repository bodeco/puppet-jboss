include 'jboss'

$url            = 'http://bamboo.corp.ositax.com:8085/browse/DM-R5610-35/artifact/shared/Determination'
$version        = '5.6.1.0-SNAPSHOT'
#$tax_host       = '10.198.220.136'
$tax_host       = '172.16.127.197'
$tax_port       = '1433'
$tax_username   = 'sbxtax'
$tax_password   = 'sbxtax'
#$audit_host     = '10.198.220.136'
$audit_host     = '172.16.127.197'
$audit_port     = '1433'
$audit_username = 'sbxtax'
$audit_password = 'sbxtax'

$filename = "taxengine-pom-${version}-customer-center-assembly.zip"
$staging_folder = regsubst($::staging_windir, '\\', '/', 'G')
$folder = "${staging_folder}/jboss/${version}"

staging::file { $filename:
  source => "${url}/${filename}",
}

file { $folder:
  ensure => directory,
}

exec { 'extract_determination':
  command => "\"C:/Program Files/7-zip/7z.exe\" x ${staging_folder}/${filename}",
  cwd     => $folder,
  creates => "${folder}/sabrix.ear",
  require => Staging::File[$filename],
}

jboss::jar { 'sqljdbc4.jar':
  source => 'puppet:///modules/jboss/sqljdbc4.jar',
}

jboss::ear { 'sabrix.ear':
  source  => "${folder}/sabrix.ear",
  require => Exec['extract_determination'],
}

jboss::conf { 'standalone/configuration/standalone.xml':
  content => template('jboss/standalone.xml.erb'),
  #source => 'puppet:///modules/jboss/standalone.xml',
}
