#!/usr/bin/env bash

set -e

BOT_USER=${BOT_USER:-buildbot}

echo "Updating package repository"
# This release of Ubuntu packages an old version of Buildbot. This old version
# is installed from `apt` and then upgraded via `pip` because the
# Ubuntu-packaged version also defines init.d scripts that facilitate running
# Buildbot as a service.
sudo apt-get update >/dev/null 2>&1

echo "Installing dependencies"
#sudo apt-get install -y git build-essential python-dev python-pip >/dev/null 2>&1
sudo apt-get install -y git buildbot python-pip python-dev >/dev/null 2>&1

echo "Upgrading Buildbot"
sudo pip install --upgrade buildbot >/dev/null 2>&1

echo "Configuring build master"
cd /var/lib/buildbot/masters
sudo buildbot create-master master
sudo ln -s /vagrant/master.cfg master
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
