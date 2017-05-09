# Why Kafka Laboratory
I was taking to long to prepare the environment every time I had to study something related to Kafka, basically because if you want to run tests in a environment with the minimum requirements for HA you need at least 3 servers for Zookeeper and 3 servers for kafka, all to ensure HA and avoid split brain.

If you are new to Kafka, I strongly recommend going through [kafka documentation](https://kafka.apache.org/documentation/), you can also take a look in [this course](https://www.youtube.com/watch?v=gg-VwXSRnmg&list=PLkz1SCf5iB4enAR00Z46JwY9GGkaS2NON), which is basic but extremely helpful.

To make it more useful, I also prepared the Zookeeper and Kafka to be both managed by [systemd](https://www.freedesktop.org/wiki/Software/systemd/), which means you can manage the services like this:
```console
systemctl start zookeeper
systemctl stop zookeeper
systemctl restart zookeeper

systemctl start kafka
systemctl stop kafka
systemctl restart kafka
```

## Prerequisites

### Installed on your desktop
* Fedora 24 (My host Operating System)
* Vagrant 1.9.4
* Virtualbox 5.1.20

### Will be installed by the automation
* CentOS 7
* Chef
* mDNS
* Zookeeper
* Kafka

## Features
* Create and boot VirtualBox instances
* Provision the hosts with all necessary tools
* You can SSH into the instances using ```vagrant ssh <host>```
* Automatic SSH key generation to access your hosts through vagrant

## Usage
After install vagrant and virtualbox on your desktop, you can clone this repo. After that, just bring up the environment whit ```vagrant up``` command, make sure you are in the right directory and Vagrantfile is on the same path where you type the command to start the provisioning.

Depending on how many hosts you require for your environment, you can change the host variables (zookeeper_boxes and kafka_boxes) on Vagrantfile.

Keep in mind that this is my personal laboratory, you can prepare you're production environment following this steps, but make sure you know what you're doing.
