#!/usr/bin/env bash
#setup repo
sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
sudo cp /vagrant/yum.repos.d/* /etc/yum.repos.d/ -rf

# update yum
sudo yum update -y
# install utilities
sudo yum install vim netstat telnet unzip ll -y

# install application
cd ~
curl -z "jdk-8u73-linux-x64.rpm" -v -j -k -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.rpm"
sudo yum -y localinstall /home/vagrant/jdk-8u73-linux-x64.rpm
sudo yum install elasticsearch kibana logstash filebeat -y

# Setup beat dashbaord
cd ~
cp /vagrant/downloads/beats-dashboards-*.zip . -rf
unzip beats-dashboards-*.zip
cd beats-dashboards-*
./load.sh
rm beats-dashboards-* -rf

# force link config files
sudo cp -rf /vagrant/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo chown :elasticsearch /etc/elasticsearch/elasticsearch.yml
sudo ln -sf /vagrant/config/kibana.yml /opt/kibana/config/kibana.yml
sudo ln -sf /vagrant/config/filebeat.yml /etc/filebeat/filebeat.yml

sudo ln -sf /vagrant/config/logstash-conf.d/02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf
sudo ln -sf /vagrant/config/logstash-conf.d/30-elasticsearch-output.conf /etc/logstash/conf.d/30-elasticsearch-output.conf

#Setup auto start and start
sudo chkconfig elasticsearch on
sudo chkconfig logstash on
sudo chkconfig kibana on
sudo chkconfig filebeat on
sudo service elasticsearch start
sudo service logstash start
sudo service kibana start
sudo service filebeat start

#load beat template into elasticsearch. after start Elasticsearch
curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@/vagrant/downloads/filebeat-index-template.json
