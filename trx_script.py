from web3 import Web3

# Параметры подключения к вашей Ethereum ноде
provider_url = 'http://127.0.0.1:52798' # el-1-geth-lighthouse
web3 = Web3(Web3.HTTPProvider(provider_url))

# Проверка подключения
if not web3.is_connected:
    print('Не удалось подключиться к узлу')
    exit()

# Параметры транзакции
from_address = "0x8943545177806ed17b9f23f0a21ee5948ecaa776"
to_address = "0x01763fa566856d519a84723dd3a1e882769c1b7d"
private_key = "bcdf20249abf0ed6d944c0288fad489e33f66b3960d9e6229c1cd214ed3bbe31"

# Получение nonce для отправителя

nonce = web3.eth.get_transaction_count(from_address)

# Создание транзакции
transaction = {
    'to': to_address,
    'value': web3.to_wei(1, 'ether'),
    'gas': 21000,
    'gasPrice': web3.to_wei('50', 'gwei'),
    'nonce': nonce,
    'chainId': 1337  # network_id
}

# Подписание транзакции
signed_txn = web3.eth.account.sign_transaction(transaction, private_key)

# Отправка транзакции
tx_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)

# Вывод хэша транзакции
print(f"Транзакция отправлена с хэшем: {web3.toHex(tx_hash)}")

# Ожидание получения подтверждения (не обязательно, но полезно для тестов)
receipt = web3.eth.waitForTransactionReceipt(tx_hash)
print(f"Транзакция подтверждена в блоке: {receipt.blockNumber}")
