#
# Cookbook Name:: Dev_CentOS7_AT_HW
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute



#Install Apache Web Server
case node['platform']
  when "debian", "ubuntu" 
   package "apache2" do
      action :install
    end
  when "redhat", "centos" 
    package "httpd" do	
      action :install
    end
end

#Install Tomcat Application Server
case node["platform"]
  when "redhat", "centos"
    package "tomcat"do
      action :install
    end
  when "debian", "ubuntu"
    package "tomcat7" do
      action :install
    end
   

end

service 'WebServer' do
  case node['platform']
  when 'centos','redhat','fedora'
    service_name 'httpd'
  else
    service_name 'apache2'
  end
  action [ :enable, :start ]
end

service 'AppServer' do
  case node['platform']
  when 'centos','redhat','fedora'
    service_name 'tomcat'
  else
    service_name 'tomcat7'
  end
  action [ :enable, :start ]
end

include_recipe 'Dev_CentOS7_AT_HW::security'

