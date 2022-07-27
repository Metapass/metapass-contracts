# Metapass Contracts

This repo is for contracts of Metapass.

There are 2 Contracts in use and 1 peripherial contract.

**Polygon Mainnet** - [MetaStorage.sol](https://polygonscan.com/address/0xEA24e80e4B7A22C2226F9730465Ca07Bc6d5Ab81)<br>
**Mumbai Testnet** - [MetaStorage.sol](https://mumbai.polygonscan.com/address/0xA53a727f7daCE0cD62C8a2308498C4D9b51DA9e1)

**Mumbai Testnet** - [StorageProxy.sol](https://mumbai.polygonscan.com/address/0x73fcAcB6B1b3323A0425CDC9bC838380C6868b5F)

Metastorage is responsible for all event emissions and writing to the graph. Any and all cuts pertaining to metapass would be stored in this contract.

**Polygon Mainnet** - [MetapassFactory.sol](https://polygonscan.com/address/0xf79f95ace4397097B681a554845eF1b35F14c0fC)<br>
**Mumbai Testnet** - [MetapassFactory.sol](https://mumbai.polygonscan.com/address/0x33dB244e8Ccbc1f9dc9291A1B929475c7c85361e)

Factory contract which generates instance of new event.
