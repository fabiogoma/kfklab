zookeeper_version = '3.4.10'
data_dir = '/var/lib/zookeeper'
zookeeper_id = node['server_id']

group 'zookeeper' do
  action :create
end

user 'zookeeper' do
  comment 'zookeeper'
  gid 'zookeeper'
  home '/home/zookeeper'
  shell '/bin/bash'
  action :create
end

directory '/home/zookeeper/install/' do
  owner 'zookeeper'
  group 'zookeeper'
  mode '0755'
  recursive true
  action :create
end

remote_file "/home/zookeeper/install/zookeeper-#{zookeeper_version}.tar.gz" do
  source "http://apache.40b.nl/zookeeper/stable/zookeeper-#{zookeeper_version}.tar.gz"
  owner 'zookeeper'
  group 'zookeeper'
  mode '0644'
  action :create
end

execute 'change permissions before unpack' do
  command 'chown -R zookeeper. /home/zookeeper/'
  action :run
end

execute 'unpack tar file' do
  command "tar -xvzf /home/zookeeper/install/zookeeper-#{zookeeper_version}.tar.gz"
  cwd '/opt/'
  action :run
end

execute 'change permissions at the destination' do
  command "chown -R zookeeper. /opt/zookeeper-#{zookeeper_version}"
  action :run
end

directory data_dir.to_s do
  owner 'zookeeper'
  group 'zookeeper'
  mode '0755'
  action :create
end

template "/opt/zookeeper-#{zookeeper_version}/conf/zoo.cfg" do
  source 'opt/zookeeper/conf/zoo.cfg.erb'
  mode '0644'
  owner 'zookeeper'
  group 'zookeeper'
  variables({
    data_dir: data_dir,
    zookeeper_server_list: node['zookeeper_server_list']
  })
end

template '/etc/systemd/system/zookeeper.service' do
  source 'etc/systemd/system/zookeeper.service.erb'
  mode '0644'
  owner 'zookeeper'
  group 'zookeeper'
  variables({
    data_dir: data_dir,
    zookeeper_version: zookeeper_version.to_s
  })
end

execute 'create id file' do
  command "echo #{zookeeper_id} > #{data_dir}/myid; chown zookeeper. #{data_dir}/myid"
  action :run
end

execute 'daemon reload' do
  command 'systemctl daemon-reload'
  action :run
end

service 'zookeeper' do
  supports status: true, restart: true, reload: true
  action [:enable, :restart]
end
