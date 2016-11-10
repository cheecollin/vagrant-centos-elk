#!/usr/bin/env bash
#setup repo
sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
sudo cp /vagrant/yum.repos.d/* /etc/yum.repos.d/ -rf

# update yum
sudo yum update -y
# install utilities
sudo yum install vim netstat telnet unzip ll -y

# install java
sudo yum install openjdk-7-jre-headless nginx apache2-utils -y
sudo yum install elasticsearch kibana logstash filebeat -y

#setup logstash config
sudo cp /vagrant/config/logstash-conf.d/* /etc/logstash/conf.d/ -rf

# Setup beat dashbaord
cd ~
cp /vagrant/downloads/beats-dashboards-*.zip . -rf
unzip beats-dashboards-*.zip
cd beats-dashboards-*
./load.sh

#load beat template into elasticsearch
curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@/vagrant/downloads/filebeat-index-template.json

# force link config files
sudo ln -sf /vagrant/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo ln -sf /vagrant/config/kibana.yml /etc/elasticsearch/elasticsearch.yml
sudo ln -sf /vagrant/config/filebeat.yml /etc/elasticsearch/elasticsearch.yml

sudo rm rm /etc/logstash/conf.d/
sudo ln -sf /vagrant/config/logstash-conf.d/ /etc/logstash/conf.d

#Setup auto start and start
sudo chkconfig elasticsearch on
sudo chkconfig logstash on
sudo chkconfig kibana on
sudo chkconfig filebeat on
sudo service elasticsearch start
sudo service logstash start
sudo service kibana start
sudo service filebeat start
