wget https://apt.puppet.com/puppet7-release-stretch.deb; 
sudo dpkg -i puppet7-release-stretch.deb; 
sudo apt update; 
sudo apt install puppetserver git -y; 
sudo systemctl start puppetserver; 
sudo apt install puppet-agent -y; 
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true; 
puppet module install computology-packagecloud --version 0.3.2; 
git clone https://github.com/nkalupahana/rundeck.git; 
cd rundeck;
sudo /opt/puppetlabs/bin/puppet apply config.pp