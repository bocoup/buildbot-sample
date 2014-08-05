#!/usr/bin/env bash

set -e

BOT_USER=${BOT_USER:-buildbot}

echo "Updating package repository"
sudo apt-get update >/dev/null 2>&1

echo "Installing dependencies"
#sudo apt-get install -y git build-essential python-dev python-pip >/dev/null 2>&1
sudo apt-get install -y git buildbot >/dev/null 2>&1

echo "Configuring build master"
cd /var/lib/buildbot/masters
sudo buildbot create-master master
sudo mv master/master.cfg.sample master/master.cfg
sudo chown -R buildbot:buildbot master
sudo cp /vagrant/daemons/buildmaster /etc/default

sudo /etc/init.d/buildmaster start

echo "Configuring build slave"
cd /var/lib/buildbot/slaves
sudo buildslave create-slave slave localhost:9989 \
  example-slave pass
sudo chown -R buildbot:buildbot slave
sudo cp /vagrant/daemons/buildslave /etc/default

sudo /etc/init.d/buildslave start
