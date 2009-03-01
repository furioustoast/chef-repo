#!/bin/bash

# See BOOTSTRAP_README

if test -z "$1"
then
  echo "Must provide the chef server IP"
  exit 1
else
  chef_ip=$1
fi

apt-get install ruby ruby1.8-dev rubygems libopenssl-ruby1.8 build-essential wget

# Replace apt-get rubygems
cd /tmp
wget http://rubyforge.org/frs/download.php/45904/rubygems-update-1.3.1.gem
sudo gem install rubygems-update-1.3.1.gem
sudo /var/lib/gems/1.8/bin/update_rubygems
sudo rm /usr/bin/gem
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

sudo gem sources -a http://gems.opscode.com
sudo gem install chef ohai  --no-rdoc --no-ri
echo "$chef_ip  chef" >> /etc/hosts

mkdir /etc/chef
cp /root/chef-repo/config/client.rb /etc/chef/

chef-client

echo "Now:"
echo "* Login at http://${chef_ip}:4000/openid/consumer "
echo "* Validate '"`hostname`"' at http://${chef_ip}:4000/registrations"
echo "* Run `chef-client` to create node entry"
echo "* Add recipes at http://${chef_ip}:4000/nodes/"`hostname`
echo "* Run `chef-client` again to run the recipes"