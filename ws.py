from web3 import Web3

# Параметры подключения к вашей Ethereum-ноде
provider_url = 'ws://127.0.0.1:50827'  # WebSocket-порт ноды el-1-geth-lighthouse
web3 = Web3(Web3.LegacyWebSocketProvider(provider_url))

# Проверка подключения
if not web3.is_connected():
  print('Не удалось подключиться к узлу')
  exit()

# Параметры транзакции
from_address = "0xD8F3183DEF51A987222D845be228e0Bbb932C222"  # Первый предзагруженный аккаунт
to_address = "0xafF0CA253b97e54440965855cec0A8a2E2399896"    # Второй предзагруженный аккаунт
private_key = "c5114526e042343c6d1899cad05e1c00ba588314de9b96929914ee0df18d46b2"  # Приватный ключ отправителя

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
