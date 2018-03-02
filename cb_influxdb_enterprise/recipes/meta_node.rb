#
# Cookbook:: cb_infra_influxdb
# Recipe:: meta_node
#
# Copyright:: 2018, Joel E White, All Rights Reserved.

# Get influxdb-data package
execute 'influxdb meta package - download' do
  cwd '/root/'
  command 'wget https://dl.influxdata.com/enterprise/releases/influxdb-meta_1.3.9-c1.3.9_amd64.deb'
end

execute 'influxDB meta package - install' do
  cwd '/root/'
  command 'dpkg -i influxdb-meta_1.3.9-c1.3.9_amd64.deb'
  not_if { ::File.exist?('/etc/influxdb/influxdb.conf') }
end

template '/etc/influxdb/influxdb-meta.conf' do
  source 'influxdb-meta.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
  variables(
    :license => node.default['license']['key']
  )
end

systemd_unit 'influxdb-meta.service' do
  action :restart
end
