#
# Cookbook:: cb_infra_influxdb
# Recipe:: data_node
#
# Copyright:: 2018, Joel E White, All Rights Reserved.

# Get influxdb-data package
execute 'influxdb data package - download' do
  cwd '/root/'
  command 'wget https://dl.influxdata.com/enterprise/releases/influxdb-data_1.3.9-c1.3.9_amd64.deb'
end

execute 'influxDB data package - install' do
  cwd '/root/'
  command 'dpkg -i influxdb-data_1.3.9-c1.3.9_amd64.deb'
  not_if { ::File.exist?('/etc/influxdb/influxdb.conf') }
end

template '/etc/influxdb/influxdb.conf' do
  source 'influxdb.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
  variables(
    :license => node.default['license']['key'],
    :secret => node.default['data']['secret'],
    :datadir => node.default['data']['data']['dir'],
    :waldir => node.default['data']['wal']['dir'],
    :hhdir => node.default['data']['hh']['dir']
  )
end

directory '/mnt/influxdb' do
  owner 'influxdb'
  group 'influxdb'
  action :create
end

directory '/mnt/influxdb/data' do
  owner 'influxdb'
  group 'influxdb'
  action :create
end

directory '/mnt/influxdb/wal' do
  owner 'influxdb'
  group 'influxdb'
  action :create
end

directory '/mnt/influxdb/hh' do
  owner 'influxdb'
  group 'influxdb'
  action :create
end

systemd_unit 'influxd.service' do
  action :restart
end

systemd_unit 'influxdb.service' do
  action :restart
end
