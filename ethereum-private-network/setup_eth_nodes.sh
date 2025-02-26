#!/bin/bash

# Названия ваших контейнеров с узлами Ethereum
NODE1="ethereum-node1"
NODE2="ethereum-node2"
ACCOUNT1="0x8e91f77514ec0d71a6644d6f983b0c668a34cd7d" # from genesis

# Пароль для новых аккаунтов (измените на свой)
PASSWORD="your_password"

# Функция для выполнения команд в Geth консоли через Docker
function geth_attach() {
  local node="$1"    # Имя контейнера
  local command="$2" # Команда для Geth
  docker exec -i "$node" geth attach --exec "$command"
}

# --- Шаг 1: Создание аккаунтов на обоих узлах ---
#echo "Создание аккаунта на $NODE1..."
#ACCOUNT1=$(geth_attach "$NODE1" "personal.newAccount('$PASSWORD')")
#echo "Аккаунт на $NODE1: $ACCOUNT1"

echo "Создание аккаунта на $NODE2..."
ACCOUNT2=$(geth_attach "$NODE2" "personal.newAccount('$PASSWORD')")
echo "Аккаунт на $NODE2: $ACCOUNT2"

# --- Шаг 2: Получение enode-адресов узлов ---
echo "Получение enode-адреса для $NODE1..."
ENODE1=$(geth_attach "$NODE1" "admin.nodeInfo.enode")
echo "ENODE1: $ENODE1"

echo "Получение enode-адреса для $NODE2..."
ENODE2=$(geth_attach "$NODE2" "admin.nodeInfo.enode")
echo "ENODE2: $ENODE2"

# --- Шаг 3: Соединение узлов как пиров ---
echo "Добавление $NODE2 как пира на $NODE1..."
geth_attach "$NODE1" "admin.addPeer($ENODE2)"

echo "Добавление $NODE1 как пира на $NODE2..."
geth_attach "$NODE2" "admin.addPeer($ENODE1)"

echo "Ожидание 60 секунд..."
sleep 60
echo "Продолжаем выполнение!"

# --- Шаг 4: Проверка подключения пиров ---
echo "Проверка пиров на $NODE1..."
geth_attach "$NODE1" "admin.peers"

echo "Проверка пиров на $NODE2..."
geth_attach "$NODE2" "admin.peers"

# --- Шаг 5 (опционально): Разблокировка аккаунта и отправка тестовой транзакции ---
# Примечание: Для отправки транзакций у аккаунтов должен быть Ether.
# В приватной сети это настраивается через genesis.json.

echo "Разблокировка аккаунта на $NODE1..."
geth_attach "$NODE1" "personal.unlockAccount('$ACCOUNT1', '$PASSWORD', 300)"

echo "Отправка 1 Ether с $ACCOUNT1 на $ACCOUNT2..."
TX_HASH=$(geth_attach "$NODE1" "eth.sendTransaction({from: '$ACCOUNT1', to: '$ACCOUNT2', value: web3.toWei(1, 'ether')})")
echo "Хеш транзакции: $TX_HASH"

echo "Проверка баланса на $NODE2..."
geth_attach "$NODE2" "web3.fromWei(eth.getBalance('$ACCOUNT2'), 'ether')"
