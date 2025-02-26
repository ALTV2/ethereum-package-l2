#!/bin/bash

# Запуск node1
echo "Запуск node1..."
docker exec -d ethereum-node1 geth --networkid 15 --maxpeers 2 --nodiscover --http --http.addr 0.0.0.0 --http.port 8545 --http.api eth,net,web3,personal,admin --allow-insecure-unlock --syncmode full --snapshot=false

# Запуск node2
echo "Запуск node2..."
docker exec -d ethereum-node2 geth --networkid 15 --maxpeers 2 --nodiscover --http --http.addr 0.0.0.0 --http.port 8545 --http.api eth,net,web3,personal,admin --allow-insecure-unlock --syncmode full --snapshot=false

echo "Ноды запущены!"
