#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='Wallet____number'
VALIDATOR='Validator____number'
PASWD='Wallet____passwd'
DELAY=100 #in secs - how often restart the script 
ACC_NAME=Wallet____name
NODE=http://localhost:26657 #change it only if you use another rpc port of your node

for (( ;; )); do
        BAL=$(omniflixhubd q  bank balances ${DELEGATOR});
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uflix\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n${PASWD}\n" | omniflixhubd tx distribution withdraw-rewards ${VALIDATOR} --chain-id flixnet-2 --from ${ACC_NAME} --gas auto -y 
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(omniflixhubd query bank balances ${DELEGATOR} --node ${NODE} -o json | jq -r '.balances  | .[].amount');
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uflix\n"
        echo -e "Stake ALL\n"
        echo -e "${PASWD}\n${PASWD}\n" | omniflixhubd tx staking delegate ${VALIDATOR} ${BAL}uflix  --chain-id flixnet-2 --from ${ACC_NAME}  --gas auto -y 
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
