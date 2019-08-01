#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "${GREEN}Running install script for debian based systems (Optimized for MEAN stack server by Bitnami on Google Cloud services)${NC}"
#ufw installation
echo -e "${GREEN}Installing UFW...${NC}"
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
echo -e "${GREEN}Installing Bitcoin Core...${NC}"
mkdir bitcoinbin
cd bitcoinbin 
wget https://bitcoin.org/bin/bitcoin-core-0.18.0/bitcoin-0.18.0-x86_64-linux-gnu.tar.gz
tar -xzf bitcoin-0.18.0-x86_64-linux-gnu.tar.gz
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
export PATH=$PATH:~/bitcoinbin/bitcoin-0.18.0/bin/bitcoind
export PATH=$PATH:~/bitcoinbin/bitcoin-0.18.0/bin/bitcoin-cli
export PATH=$PATH:~/builds/lightning/lightningd
export PATH=$PATH:~/builds/lightning/cli
cd /usr/bin/
sudo ln -s ~/bitcoinbin/bitcoin-0.18.0/bin/bitcoind bitcoind
sudo ln -s ~/bitcoinbin/bitcoin-0.18.0/bin/bitcoin-cli bitcoin-cli
sudo ln -s ~/builds/lightning/lightningd/lightningd lightningd
sudo ln -s ~/builds/lightning/cli/lightning-cli lightning-cli
source ~/.bashrc
source ~/.profile
echo -e "${GREEN}Finishing up...${NC}"
cd ~
sudo npm i -g npm
sudo npm install -g forever
sudo npm install -g yarn 
#lighting charge has errors when installed with NPM, we use yarn instead
sudo yarn global add lightning-charge
cd ~
mkdir lightning-logs
mkdir chargedb
mkdir .lightning
cp ~/lightning-installer/scripts/gcs_mean_bitnami/config ~/.lightning/
immortal bitcoind --daemon
echo -e "${GREEN}Installation completed! Now wait 12+ hours for bitcoin node to fully sync!${NC}"