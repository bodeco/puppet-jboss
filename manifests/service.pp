# class: JBoss service
class jboss::service inherits jboss::params {
  service { $jboss::params::service_name:
    ensure => running,
    enable => true,
  }
}
