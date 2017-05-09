kafka_version = '0.10.2.1'
scala_version = '2.12'
data_dir = '/var/lib/kafka'

group 'kafka' do
  action :create
end

user 'kafka' do
  comment 'kafka'
  gid 'kafka'
  home '/home/kafka'
  shell '/bin/bash'
  action :create
end

directory '/home/kafka/install/' do
  owner 'kafka'
  group 'kafka'
  mode '0755'
  recursive true
  action :create
end

directory "#{data_dir}/kafka-logs" do
  owner 'kafka'
  group 'kafka'
  mode '0755'
  recursive true
  action :create
end

remote_file "/home/kafka/install/kafka_#{scala_version}-#{kafka_version}.tgz" do
  source "http://apache.proserve.nl/kafka/#{kafka_version}/kafka_#{scala_version}-#{kafka_version}.tgz"
  owner 'kafka'
  group 'kafka'
  mode '0644'
  action :create
end

execute 'change permissions before unpack' do
  command 'chown -R kafka. /home/kafka/'
  action :run
end

execute 'unpack tar file' do
  command "tar -xvzf /home/kafka/install/kafka_#{scala_version}-#{kafka_version}.tgz"
  cwd '/opt/'
  action :run
end

execute 'change permissions at the destination' do
  command "chown -R kafka. /opt/kafka_#{scala_version}-#{kafka_version}"
  action :run
end

zookeeper_server_list = ''
node['zookeeper_server_list'].each_with_index do |zookeeper_host, index|
  zookeeper_server_list += "#{zookeeper_host}.local:2181,"
end

template "/opt/kafka_#{scala_version}-#{kafka_version}/config/server.properties" do
  source 'opt/kafka/config/server.properties.erb'
  mode '0644'
  owner 'kafka'
  group 'kafka'
  variables({
    index: node['server_id'],
    hostname: node['hostname'],
    data_dir: data_dir,
    zookeeper_server_list: zookeeper_server_list.chomp(',')
  })
end

template '/etc/systemd/system/kafka.service' do
  source 'etc/systemd/system/kafka.service.erb'
  mode '0644'
  owner 'kafka'
  group 'kafka'
  variables({
    kafka_folder: "kafka_#{scala_version}-#{kafka_version}"
  })
end

execute 'daemon reload' do
  command 'systemctl daemon-reload'
  action :run
end

service 'kafka' do
  supports status: true, restart: true, reload: true
  action [:enable, :restart]
end
