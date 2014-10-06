#
# Cookbook Name:: megam_op5
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.set['logstash']['key'] = "#{node.name}"
#node.set['logstash']['output']['url'] = "www.megam.co"
node.set['logstash']['output']['url'] = "localhost"
node.set['logstash']['beaver']['inputs'] = [ "/var/log/upstart/gulpd.log" ]


#=begin
node.set['rsyslog']['index'] = "#{node.name}"
#node.set['rsyslog']['elastic_ip'] = "monitor.megam.co.in"
node.set['rsyslog']['elastic_ip'] = "localhost"
node.set['rsyslog']['input']['files'] = [ "/var/log/upstart/gulpd.log" ]

#=end

scm_ext = File.extname(node['megam']['deps']['node']['predefs']['scm'])
file_name = File.basename(node['megam']['deps']['node']['predefs']['scm'])
dir = File.basename(file_name, '.*')

node.set["gulp"]["project_name"] = "#{dir}"
node.set["gulp"]["email"] = "#{node['megam']['deps']['account']['email']}"
node.set["gulp"]["api_key"] = "#{node['megam']['deps']['account']['api_key']}"


node.set['megam']['env']['home'] = "#{node['megam']['user']['home']}/op5"
include_recipe "megam_environment"

directory "#{node['megam']['user']['home']}/op5"

remote_file "#{node['megam']['user']['home']}/op5/#{file_name}" do
  source node['megam']['deps']['node']['predefs']['scm']
  mode "0755"
   owner node['megam']['default']['user']
  group node['megam']['default']['user']
end

execute "Untar op5-monitor" do
cwd "#{node['megam']['user']['home']}/op5"
  user "root"
  group "root"
  command "tar --strip-components=1 -zxvf #{file_name}"
end

execute "Install op5" do
cwd "/#{node['megam']['user']['home']}/op5"
  user "root"
  group "root"
  command "./install.sh"
end


#include_recipe "megam_gulp"

