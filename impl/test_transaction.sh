#!/bin/bash

# Названия контейнеров
NODE1="ethereum-node1"
NODE2="ethereum-node2"

# Пароль для разблокировки аккаунта (тот же, что и при создании)
PASSWORD="your_password"

# Адреса аккаунтов (предполагается, что они уже созданы)
# Замените на реальные адреса ваших аккаунтов
ACCOUNT1="0xYourAccount1Address"
ACCOUNT2="0xYourAccount2Address"

# Сумма для отправки (в Wei, 1 Ether = 10^18 Wei)
AMOUNT=$(geth_attach "$NODE1" "web3.toWei(1, 'ether')")

# Функция для выполнения команд в Geth консоли
function geth_attach() {
  local node=$1
  local command=$2
  docker exec -i "$node" geth attach --exec "$command"
}

# --- Шаг 1: Разблокировать аккаунт отправителя на NODE1 ---
echo "Разблокировка аккаунта $ACCOUNT1 на $NODE1..."
geth_attach "$NODE1" "personal.unlockAccount('$ACCOUNT1', '$PASSWORD', 300)"

# --- Шаг 2: Отправить транзакцию с NODE1 на NODE2 ---
echo "Отправка $AMOUNT Wei с $ACCOUNT1 на $ACCOUNT2..."
TX_HASH=$(geth_attach "$NODE1" "eth.sendTransaction({from: '$ACCOUNT1', to: '$ACCOUNT2', value: $AMOUNT})")
echo "Хеш транзакции: $TX_HASH"

# --- Шаг 3: Проверить статус транзакции на NODE1 ---
echo "Проверка статуса транзакции..."
sleep 5  # Подождать немного, чтобы транзакция была обработана
TX_RECEIPT=$(geth_attach "$NODE1" "eth.getTransactionReceipt('$TX_HASH')")

if [ "$TX_RECEIPT" != "null" ]; then
  echo "Транзакция успешно включена в блок."
else
  echo "Транзакция еще не включена в блок или не найдена."
  exit 1
fi

# --- Шаг 4: Проверить баланс получателя на NODE2 ---
echo "Проверка баланса аккаунта $ACCOUNT2 на $NODE2..."
BALANCE=$(geth_attach "$NODE2" "web3.fromWei(eth.getBalance('$ACCOUNT2'), 'ether')")
echo "Баланс аккаунта $ACCOUNT2: $BALANCE Ether"

# --- Шаг 5: Валидация ---
EXPECTED_BALANCE=1  # Ожидаемый прирост баланса (в Ether)
if (( $(echo "$BALANCE >= $EXPECTED_BALANCE" | bc -l) )); then
  echo "Тестовая транзакция успешно выполнена и валидирована."
else
  echo "Ошибка: баланс не увеличился на ожидаемую сумму."
fi
