wget https://apt.puppet.com/puppet6-release-jessie.deb; 
sudo dpkg -i puppet6-release-jessie.deb; 
sudo apt update;
sudo apt install puppetserver git -y --force-yes; 
sudo systemctl start puppetserver; 
sudo apt install puppet-agent -y --force-yes; 
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true; 

sudo /opt/puppetlabs/bin/puppet module install puppet-rundeck;
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-java;
sudo /opt/puppetlabs/bin/puppet module install crayfishx-firewalld;
sudo /opt/puppetlabs/bin/puppet module install puppetlabs/apt;

git clone https://github.com/nkalupahana/rundeck.git; 
cd rundeck;
sudo /opt/puppetlabs/bin/puppet apply config.pp