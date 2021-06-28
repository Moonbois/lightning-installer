#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
echo -e "${GREEN}Running UPDATE script for debian based systems (Optimized for MEAN stack server by Bitnami on Google Cloud services)${NC}"
echo -e "${GREEN}Stopping immortal and bitcoin daemon...${NC}"
#stop immortal and bitcoin 
immortalctl stop "*"
bitcoin-cli stop
echo -e "${GREEN}Getting new bitcoin version...${NC}"
cd ~
rm -rf bitcoinbin/
mkdir bitcoinbin
cd bitcoinbin 
wget https://bitcoin.org/bin/bitcoin-core-0.21.1/bitcoin-0.21.1-x86_64-linux-gnu.tar.gz
tar -xzf bitcoin-0.21.1-x86_64-linux-gnu.tar.gz
cd ~
immortal bitcoind --daemon
immortal lightningd
echo -e "${GREEN}Update finished!${NC}"
echo -e "${RED}Please MANUALLY run immortal charged with right credentials!${NC}"
