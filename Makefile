-include .env

.PHONY: test clean update build snapshot format anvil deploy verify

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network mumbai\""

clean  :; forge clean

update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

# anvil with mnemonic and continuous tracing
anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

# local network by default
NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

# if the network is mumbai, use the mumbai rpc url and private key
ifeq ($(findstring --network mumbai,$(ARGS)),--network mumbai)
	NETWORK_ARGS := --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(POLYGONSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script --legacy script/DeployQtoken.s.sol:DeployQtoken $(NETWORK_ARGS)

# make the contract verified on polygonscan
verify:
	@forge verify-contract --chain-id 80001 --num-of-optimizations 200 --watch --etherscan-api-key $(POLYGONSCAN_API_KEY) --compiler-version v0.8.19+commit.7dd6d404 0x089dc24123e0a27d44282a1ccc2fd815989e3300 src/Qtoken.sol:Qtoken