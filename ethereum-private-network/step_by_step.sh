#docker cp genesis.json ethereum-node1:/root/.ethereum/genesis.json
#docker cp genesis.json ethereum-node2:/root/.ethereum/genesis.json
#docker exec -it ethereum-node1 geth init /root/.ethereum/genesis.json
#docker exec -it ethereum-node2 geth init /root/.ethereum/genesis.json
#docker-compose down
#docker-compose up -dьш

#docker exec -it ethereum-node1 geth --exec "admin.nodeInfo.enode" attach http://localhost:8545

#docker exec -it ethereum-node1 geth --exec "admin.addPeer('enode://b7a486463cfe1dfb18030c7adf0e5695cd7a702ab185f3d65892c0af23d02d2be4e50a788e7771cf3bbe4828c97ceb97ced1065bd4e51b2f9a8da8f5e21f616f@ethereum-node2:30303?discport=0')" attach http://localhost:8545
# и наоборот
#docker exec -it ethereum-node1 geth --exec "admin.peers" attach http://localhost:8545
# и наоборот
#personal.newAccount("my_password")
#eth.accounts
#eth.getBalance(eth.accounts[0])
#добавляем кефир через genesis
  #или
#eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[0], value: web3.toWei(100, "ether")})
