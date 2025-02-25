#!/bin/bash

NODE1="ethereum-node1"
NODE2="ethereum-node2"
PASSWORD="your_password2"

function geth_attach() {
  local node="$1"
  local command="$2"
  docker exec -i "$node" geth attach --exec "$command"
}

# --- Шаг 1: Создание аккаунтов ---
echo "Создание аккаунта на $NODE1..."
ACCOUNT1=$(geth_attach "$NODE1" "personal.newAccount('$PASSWORD')" | tr -d '"')
echo "Аккаунт на $NODE1: $ACCOUNT1"

echo "Создание аккаунта на $NODE2..."
ACCOUNT2=$(geth_attach "$NODE2" "personal.newAccount('$PASSWORD')" | tr -d '"')
echo "Аккаунт на $NODE2: $ACCOUNT2"

# --- Шаг 2: Получение и корректировка enode-адресов ---
echo "Получение enode-адреса для $NODE1..."
ENODE1=$(geth_attach "$NODE1" "admin.nodeInfo.enode" | sed 's/127.0.0.1/host.docker.internal/')
echo "ENODE1: $ENODE1"

echo "Получение enode-адреса для $NODE2..."
ENODE2=$(geth_attach "$NODE2" "admin.nodeInfo.enode" | sed 's/127.0.0.1/host.docker.internal/' | sed 's/30303/30304/')
echo "ENODE2: $ENODE2"

# --- Шаг 3: Соединение узлов ---
echo "Добавление $NODE2 как пира на $NODE1..."
geth_attach "$NODE1" "admin.addPeer($ENODE2)"

echo "Добавление $NODE1 как пира на $NODE2..."
geth_attach "$NODE2" "admin.addPeer($ENODE1)"

# --- Шаг 4: Проверка подключения ---
echo "Проверка пиров на $NODE1..."
geth_attach "$NODE1" "admin.peers"

echo "Проверка пиров на $NODE2..."
geth_attach "$NODE2" "admin.peers"

# --- Шаг 5: Тестовая транзакция (Clique) ---
echo "Разблокировка аккаунта на $NODE1..."
geth_attach "$NODE1" "personal.unlockAccount('$ACCOUNT1', '$PASSWORD', 300)"

echo "Отправка 1 Ether с $ACCOUNT1 на $ACCOUNT2..."
TX_HASH=$(geth_attach "$NODE1" "eth.sendTransaction({from: '$ACCOUNT1', to: '$ACCOUNT2', value: web3.toWei(1, 'ether')})")
echo "Хеш транзакции: $TX_HASH"

echo "Ожидание обработки транзакции (Clique signer на NODE1)..."
sleep 20  # Даем время на создание блока

echo "Проверка баланса на $NODE2..."
BALANCE=$(geth_attach "$NODE2" "web3.fromWei(eth.getBalance('$ACCOUNT2'), 'ether')")
echo "Баланс на $ACCOUNT2: $BALANCE Ether"
