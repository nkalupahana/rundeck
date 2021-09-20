wget https://apt.puppet.com/puppet7-release-xenial.deb; 
sudo dpkg -i puppet7-release-xenial.deb; 
sudo apt update;
sudo apt install puppetserver git -y --force-yes; 
sudo systemctl start puppetserver; 
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true; 

wget -O rundeck.tar.gz "https://firebasestorage.googleapis.com/v0/b/nisa-la.appspot.com/o/rundeck.tar.gz?alt=media&token=b5f7c776-6b91-457e-a01d-890da7992089";

sudo /opt/puppetlabs/bin/puppet module install ./rundeck.tar.gz;
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-java;
sudo /opt/puppetlabs/bin/puppet module install crayfishx-firewalld;
sudo /opt/puppetlabs/bin/puppet module install puppetlabs/apt;

git clone https://github.com/nkalupahana/rundeck.git; 
cd rundeck;
sudo /opt/puppetlabs/bin/puppet apply config.pp