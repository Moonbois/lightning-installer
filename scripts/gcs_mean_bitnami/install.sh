#install script for debian based systems
#ufw installation
cd ~
sudo apt-get update
sudo apt-get install ufw
sudo ufw disable
sudo ufw default deny incoming 
sudo ufw default allow outgoing 
sudo ufw allow ssh  
sudo ufw allow http 
sudo ufw allow https 
sudo ufw allow 9735/tcp 
sudo ufw allow 9735/udp 
sudo ufw allow 9735 
sudo ufw enable
#bitcoin core installation
mkdir bitcoinbin
cd bitcoinbin 
wget https://bitcoin.org/bin/bitcoin-core-0.16.1/bitcoin-0.16.1-x86_64-linux-gnu.tar.gz 
tar -xzf bitcoin-0.16.1-x86_64-linux-gnu.tar.gz
cd ~
#immortal installation
curl -s https://packagecloud.io/install/repositories/immortal/immortal/script.deb.sh | sudo bash 
sudo apt-get install immortal 
#lightning installation
sudo apt-get update 
sudo apt-get install -y autoconf automake build-essential git libtool libgmp-dev libsqlite3-dev python python3 net-tools zlib1g-dev
mkdir builds
cd builds
git clone https://github.com/ElementsProject/lightning.git
cd lightning
./configure
make
cd ~
# symlink config
export PATH=$PATH:~/bitcoinbin/bitcoin-0.16.1/bin/bitcoind
export PATH=$PATH:~/bitcoinbin/bitcoin-0.16.1/bin/bitcoin-cli
export PATH=$PATH:~/builds/lightning/lightningd
export PATH=$PATH:~/builds/lightning/cli
cd /usr/bin/
sudo ln -s ~/bitcoinbin/bitcoin-0.16.1/bin/bitcoind bitcoind
sudo ln -s ~/bitcoinbin/bitcoin-0.16.1/bin/bitcoin-cli bitcoin-cli
sudo ln -s ~/builds/lightning/lightningd/lightningd lightningd
sudo ln -s ~/builds/lightning/cli/lightning-cli lightning-cli
source ~/.bashrc
source ~/.profile
cd ~
sudo npm i -g npm
sudo npm install -g forever
#lighting charge does not want to install outside of /opt/bitnami/nodejs/lib folder
cd /opt/bitnami/nodejs/lib
sudo npm install lightning-charge
cd ~
mkdir lightning-logs
mkdir chargedb
mkdir .lightning
cp ~/lightning-installer/scripts/gcs_mean_bitnami/config ~/.lightning/
immortal bitcoind --daemon
# wait 12+ hours for bitcoin node to fully sync



#crontab -e
#@reboot immortal bitcoind --daemon
#@reboot immortal lightningd
#@reboot immortal charged --api-token mySecretToken --db-path /home/bitnami/chargedb/charge.db