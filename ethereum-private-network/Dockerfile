FROM ethereum/client-go:v1.10.26

COPY genesis.json /genesis.json

RUN geth init /genesis.json --datadir /root/.ethereum

CMD ["geth", "--networkid", "15", "--maxpeers", "2", "--nodiscover", "--http", "--http.addr", "0.0.0.0", "--http.port", "8545", "--http.api", "eth,net,web3,personal,admin", "--allow-insecure-unlock", "--syncmode", "full", "--snapshot=false"]
