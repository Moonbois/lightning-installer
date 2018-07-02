#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "${GREEN}Installing lightning-charge...${NC}"
cd /usr/lib
sudo npm install lightning-charge
echo -e "Installation complete...${NC}"