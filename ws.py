from web3 import Web3

# Параметры подключения к вашей Ethereum-ноде
provider_url = 'ws://127.0.0.1:52799'  # WebSocket-порт ноды el-1-geth-lighthouse
web3 = Web3(Web3.LegacyWebSocketProvider(provider_url))

# Проверка подключения
if not web3.is_connected():
  print('Не удалось подключиться к узлу')
  exit()

# Параметры транзакции
from_address = "0x8943545177806ED17B9F23F0a21ee5948eCaa776"  # Первый предзагруженный аккаунт
to_address = "0xE25583099BA105D9ec0A67f5Ae86D90e50036425"    # Второй предзагруженный аккаунт
private_key = "bcdf20249abf0ed6d944c0288fad489e33f66b3960d9e6229c1cd214ed3bbe31"  # Приватный ключ отправителя

# Получение nonce для отправителя
nonce = web3.eth.get_transaction_count(from_address)

# Создание транзакции
transaction = {
  'to': to_address,
  'value': web3.to_wei(1, 'ether'),
  'gas': 21000,
  'gasPrice': web3.to_wei('50', 'gwei'),
  'nonce': nonce,
  'chainId': 3151908  # Chain ID вашей сети
}

# Подписание транзакции
signed_txn = web3.eth.account.sign_transaction(transaction, private_key)

# Отправка транзакции
tx_hash = web3.eth.send_raw_transaction(signed_txn.raw_transaction)

# Вывод хэша транзакции
print(f"Транзакция отправлена с хэшем: {web3.to_hex(tx_hash)}")

# Ожидание подтверждения (опционально)
receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
print(f"Транзакция подтверждена в блоке: {receipt.blockNumber}")
