#
# Cookbook Name:: Dev_CentOS7_AT_HW
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

#Include dependencies


cookbook_file 'sample.war' do
  mode '0755'
  action :create_if_missing
end

execute 'extract and deploy' do
  command 'cp -n sample.war /usr/share/tomcat/webapps/'
end

service 'AppServer' do
  case node['platform']
  when 'centos','redhat','fedora'
    service_name 'tomcat'
  else
    service_name 'tomcat7'
  end
  action :enable
end

##Install and configure mod_jk, apache and tomcat should exists CentOS
## Packages 'httpd-devel', 'apr', 'apr-devel', 'apr-util', 'apr-util-devel', 'gcc', 'gcc-c++', 'make', 'autoconf', 'libtool'

package ['httpd-devel', 'apr', 'apr-devel', 'apr-util', 'apr-util-devel', 'gcc', 'gcc-c++', 'make', 'autoconf', 'libtool']

mod_jk_path = '/tmp/mod_jk/'
mod_jk_file = 'tomcat-connectors-1.2.41-src.tar.gz'
modules = '/usr/lib64/httpd/modules'

directory mod_jk_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file "#{mod_jk_path}#{mod_jk_file}" do	
  source "http://www-us.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.41-src.tar.gz"
  mode '0755'
  not_if { ::File.exists?("#{mod_jk_path}#{mod_jk_file}") }
end

bash "compile_mod_jk" do
  user 'root'
  code <<-EOH
    cd #{mod_jk_path}
    tar -xvf #{mod_jk_file} 
    cd  #{mod_jk_path}/tomcat-connectors-1.2.41-src/native  
    ./configure --with-apxs=/usr/bin/apxs
    make
    libtool --finish #{modules}
    make install
  EOH
end

#Create mod_jk configuration from template and attributes /etc/httpd/conf.d/mod_jk.conf
template '/etc/httpd/conf.d/mod_jk.conf' do
  source 'mod_jk.conf.erb'
  mode '0440'
  owner 'apache'
  group 'apache'
end

#Create /var/run/mod_jk folder to host files for workers
directory '/var/run/mod_jk' do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

#Create workers.properties from attributes and templates in chef /etc/httpd/conf/workers.properties
template '/etc/httpd/conf/workers.properties' do
  source 'workers.properties.erb'
  mode '0440'
  owner 'apache'
  group 'apache'
end


#Create worker.conf from attributes and templates in chef
template '/etc/httpd/conf.d/worker1.conf' do
  source 'worker1.conf.erb'
  mode '0440'
  owner 'apache'
  group 'apache'
end

directory '/etc/apache2' do
  recursive true
  action :delete
end

service 'WebServer' do
 case node['platform']
   when 'centos','redhat','fedora'
     service_name 'httpd'
   else
     service_name 'apache2'
   end
 action :restart
end


