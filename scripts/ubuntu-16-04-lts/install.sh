#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "${GREEN}Running install script for Ubuntu 16.04 LTS systems${NC}"
#Node.JS instalation
cd ~
echo -e "${GREEN}Installing Node.JS${NC}"
sudo apt-get update
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
#ufw installation
echo -e "${GREEN}Installing UFW...${NC}"
cd ~
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
echo -e "${GREEN}Installing Bitcoin Core...${NC}"
mkdir bitcoinbin
cd bitcoinbin 
wget https://bitcoin.org/bin/bitcoin-core-0.16.3/bitcoin-0.16.3-x86_64-linux-gnu.tar.gz
tar -xzf bitcoin-0.16.3-x86_64-linux-gnu.tar.gz
cd ~
#immortal installation
echo -e "${GREEN}Installing Immortal...${NC}"
curl -s https://packagecloud.io/install/repositories/immortal/immortal/script.deb.sh | sudo bash 
sudo apt-get install immortal 
#lightning installation
echo -e "${GREEN}Installing Lightning...${NC}"
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
echo -e "${GREEN}Creating symlinks...${NC}"
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
echo -e "${GREEN}Finishing up...${NC}"
cd ~
sudo npm i -g npm
sudo npm install -g forever
#lighting charge does not want to install outside of /usr/lib folder
cd /usr/lib
sudo npm install lightning-charge
cd ~
mkdir lightning-logs
mkdir chargedb
mkdir .lightning
cp ~/lightning-installer/scripts/gcs_mean_bitnami/config ~/.lightning/
immortal bitcoind --daemon
echo -e "${GREEN}Installation completed! Now wait 12+ hours for bitcoin node to fully sync!${NC}"