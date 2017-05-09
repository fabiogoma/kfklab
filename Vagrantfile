zookeeper_boxes = %w(zookeeper1 zookeeper2 zookeeper3)
kafka_boxes = %w(kafka1 kafka2 kafka3)

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'
  config.vm.box_version = '1703.01'
  config.vm.network 'private_network', :type => 'dhcp', :name => 'vboxnet0', :adapter => 2
  config.vm.synced_folder '.', '/vagrant', disabled: true

  zookeeper_boxes.each_with_index do |box, index|
    config.vm.define box.to_s do |node|
      node.vm.hostname = box.to_s
      node.vm.provision 'chef_solo' do |chef|
        chef.synced_folder_type = 'rsync'
        chef.cookbooks_path = 'cookbooks'
        chef.add_recipe 'zookeeper-lab'
        chef.json = { 'zookeeper_server_list' => zookeeper_boxes, 'server_id' => index }
      end
    end
  end

  kafka_boxes.each_with_index do |box, index|
    config.vm.define box.to_s do |node|
      node.vm.hostname = box.to_s
      node.vm.provision 'chef_solo' do |chef|
        chef.synced_folder_type = 'rsync'
        chef.cookbooks_path = 'cookbooks'
        chef.add_recipe 'kafka-lab'
        chef.json = { 'zookeeper_server_list' => zookeeper_boxes, 'server_id' => index }
      end
    end
  end

end
