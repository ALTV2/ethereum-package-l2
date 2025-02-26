#!/bin/bash
docker cp genesis.json ethereum-node1:/root/.ethereum/genesis.json
docker cp genesis.json ethereum-node2:/root/.ethereum/genesis.json

# Инициализация node1
echo "Инициализация node1..."
#docker exec -it ethereum-node1 geth --datadir /root/.ethereum init /genesis.json
docker exec -it ethereum-node1 geth init /root/.ethereum/genesis.json

# Инициализация node2
echo "Инициализация node2..."
#docker exec -it ethereum-node2 geth --datadir /root/.ethereum init /genesis.json
docker exec -it ethereum-node2 geth init /root/.ethereum/genesis.json

echo "Инициализация завершена!"


