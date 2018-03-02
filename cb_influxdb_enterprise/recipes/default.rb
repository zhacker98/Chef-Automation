#
# Cookbook:: cb_infra_influxdb
# Recipe:: default
#
# Copyright:: 2018, Joel E White, All Rights Reserved.

## Need to add logic to select recipe based on Hostname

if node["hostname"].include? "influx-meta-"
  include_recipe "cb_infra_influxdb::meta_node"
end
if node["hostname"].include? "influx-data-"
  include_recipe "cb_infra_influxdb::data_node"
end
