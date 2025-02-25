FROM ethereum/client-go:v1.10.26

COPY genesis.json /genesis.json

ENTRYPOINT ["sh", "-c", "geth --datadir /root/.ethereum init /genesis.json && geth $@"]
