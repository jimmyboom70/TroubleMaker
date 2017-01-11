chef_gem 'chef-provisioning-vsphere' do
  action :install
  compile_time true
end

require 'chef/provisioning/vsphere_driver'

with_vsphere_driver host: '10.22.53.32',
  insecure: true,
  user:     'Administrator@vsphere.local',
  password: 'Epam2016'

with_machine_options :bootstrap_options => {
  use_linked_clone: true,
  num_cpus: 1,
  memory_mb: 2048,
  datacenter: 'Datacenter',
  template_name: 'centos7template',
  customization_spec: {
    ipsettings: {
     :domain => 'local'
      },
    :ssh => {
    :user => 'root',
    :password => 'Epam2016',
    :paranoid => false,
    }
  }
}
machine "testvm" do
  run_list ['centos7template::default']
end
