#
# Cookbook Name:: uaitilinuxserver
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# instala dependencias
package ['git', 'vim', 'nmap', 'unzip', 'mcrypt'] do
	action :install
end

# define o timezone
execute "timezone" do
	command "timedatectl set-timezone America/Sao_Paulo"
end
# instala o locale
execute "locale" do
	command "locale-gen pt_BR.utf8"
end

# cria o usuario
user node['uaitilinuxserver']['server_user'] do
	home node['uaitilinuxserver']['home_dir']
	shell '/bin/bash'
	manage_home true
	password node['uaitilinuxserver']['server_user_pass']
	action [:create, :modify]
end
group 'adm' do
	members [node['uaitilinuxserver']['server_user']]
	append true
	action :modify
end
group 'sudo' do
	members [node['uaitilinuxserver']['server_user']]
	append true
	action :modify
end
# copia a chave ssh de deploy
directory node['uaitilinuxserver']['home_dir'] + '/.ssh' do
	owner node['uaitilinuxserver']['server_user']
	group node['uaitilinuxserver']['server_user']
	action :create
end
template node['uaitilinuxserver']['home_dir'] + "/.ssh/id_rsa.pub" do
	source "id_rsa.pub.erb"
	owner node['uaitilinuxserver']['server_user']
	group node['uaitilinuxserver']['server_user']
	mode '0644'
end
template node['uaitilinuxserver']['home_dir'] + "/.ssh/id_rsa" do
	source "id_rsa.erb"
	owner node['uaitilinuxserver']['server_user']
	group node['uaitilinuxserver']['server_user']
	mode '0644'
end

# 
