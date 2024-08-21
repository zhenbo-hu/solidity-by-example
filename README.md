# Solidity by Example

Following [solidity-by-example.org](https://solidity-by-example.org), learn solidity, foundry and other smart contract development tools.

## How to use

```shell
forge install OpenZeppelin/openzeppelin-contracts # use openzeppelin contracts
```

build your own `.env` file

```shell
PRIVATE_KEY="YOUR_OWN_WALLET_PRIVATE_KEY"
ETH_RPC_URL="BLOCKCHAIN_NETWORK_RPC_URL"
ETHERSCAN_API_KEY="ETHERSCAN_API_KEY"
```

```shell
forge build # compile this project

forge test # run test

forge coverage # see the coverage report

forge script script/xxxx.s.sol --rpc-url $RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY --broadcast --verify -vvvv # deploy and verify via script
```
