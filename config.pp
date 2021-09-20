include java
include rundeck
include firewalld

firewalld_port { 'Rundeck HTTP port':
  ensure   => present,
  zone     => 'public',
  port     => 4440,
  protocol => 'tcp',
}

Class['java'] -> Class['rundeck']
