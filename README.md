# QXToken

QXToken ERC20 contract, tests and deployment scripts, all written in Solidity.

## Getting Started

### Prerequisites

- Foundry (https://book.getfoundry.sh/getting-started/installation)

### Installing

- Clone the repository
```bash
git clone https://github.com/qx-ventures/qxtoken.git && cd qxtoken
```
- Install the libraries
```bash
forge install
```
- Compile contracts
```bash
forge compile
```
- Run the tests on local blockchain
```bash
forge test -vvvv
```
- Run the tests on forked chain
```bash
forge test -vvvv --fork-url <ALCHEMY_RPC_URL>
```
- Check the coverage of the tests
```bash
forge coverage
```

*You can also run the commands from the Makefile.*

## Development

- Create a local blockchain
```bash
make anvil
```
- Run the tests
```bash
make test
```
- Deploy locally
```bash
make deploy
```
- Verify the contract
```bash
make verify
```
- Call the deployed contract to check user balance
```bash
cast call <DEPLOYED_ADDRESS> \
  "balanceOf(address)(uint256)" <USER_ADDRESS>
```



## Deployment

- Create a .env file with the contents of .env.example and fill in the values.

- Make sure you have enough ETH in your wallet to pay for the deployment.

- Run the deployment script
```bash
make deploy ARGS="--network <NETWORK>"
```

## Current deployed contracts

- Polygon Mumbai Testnet:
  - Qtoken: https://mumbai.polygonscan.com/address/0x98210494dd6c0e8b487888b1c7c29d613bf53bb6

- Polygon Amoy Testnet:
  - QXToken: https://amoy.polygonscan.com/token/0x98210494dd6c0e8b487888b1c7c29d613bf53bb6