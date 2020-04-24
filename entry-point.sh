#!/bin/sh

CHAINID=$1
GENACCT=$2

if [ -z "$1" ]; then
  echo "Need to input chain id..."
  exit 1
fi

if [ -z "$2" ]; then
  echo "Need to input genesis account address..."
  exit 1
fi

# Build genesis file incl account for passed address
coins="100000000000coco,100000000000mdm"
cocod init --chain-id $CHAINID $CHAINID
cococli keys add validator --keyring-backend="test"
cocod add-genesis-account validator $coins --keyring-backend="test"
cocod add-genesis-account $GENACCT $coins --keyring-backend="test"
cocod gentx --name validator --amount 100000000coco --keyring-backend="test"
cocod collect-gentxs

# Set proper defaults and change ports
sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:26657"#g' ~/.cocod/config/config.toml
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/g' ~/.cocod/config/config.toml
sed -i 's/timeout_propose = "3s"/timeout_propose = "1s"/g' ~/.cocod/config/config.toml
sed -i 's/index_all_keys = false/index_all_keys = true/g' ~/.cocod/config/config.toml

#enable: while using docker
cocod start --pruning=nothing
