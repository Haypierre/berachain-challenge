# Berachain Home Assignment

This repository contains the Berachain Home Assignment solution.

Probleme: implement a Token Factory contract to deploy ERC-20 tokens. The ERC-20 tokens deployed by the Token Factory
and the Token Factory itself should be upgradable. We should also determine the ownership of the deployed tokens, that
is the sender who calls into the Token Factory contract to create a new token must be the owner of the token. Only the
token’s owner can upgrade its implementation. The Token Factory contract should have a function for the owner of the
token upgrading the token.

I've decided to go with the openzeppelin UUPS Proxy pattern.

Run unit test: `forge test`

Deployed ERC20FactoryContract:
[0xBA5D20A1496d7e7b766E818d48a34F910fc51cBA](https://sepolia.etherscan.io/address/0xBA5D20A1496d7e7b766E818d48a34F910fc51cBA)

TODO: real world testing on Sepolia & Berachain’s testnet!
