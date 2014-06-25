# class: jboss service
class jboss::service {
  service { 'JBOSS_EAP_SERVICE':
    ensure => running,
    enable => true,
  }
}
