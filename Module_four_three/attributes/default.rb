#Attributes required to compile mod_jk in CentOS
default[:mod_jk][:module_path]	= "\"/etc/httpd/modules/mod_jk.so\""
default[:mod_jk][:workerproperties_path]	= "/etc/httpd/conf/workers.properties"
default[:mod_jk][:shm_path]	= "/var/run/httpd/mod_jk.shm"
default[:mod_jk][:log_path]	= "/var/log/httpd/mod_jk.log"

#Attributes required to build workers.properties
default[:mod_jk][:worker_path] = "/var/log/httpd"
default[:mod_jk][:worker_names] = "worker23"
default[:mod_jk][:worker_type] = "ajp13"
default[:mod_jk][:worker_host] = "localhost"
default[:mod_jk][:worker_port] = "8009"

#Attributes required to build worker.conf
default[:mod_jk][:worker_serveradmin] = "your_mail@epam.com"
default[:mod_jk][:customlog] = "/var/log/httpd/app1_access.log"
default[:mod_jk][:errorlog] = "/var/log/httpd/app1_error.log"
