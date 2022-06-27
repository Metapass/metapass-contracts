# Metapass Contracts

This repo is for contracts of Metapass.

There are 2 Contracts in use and 1 peripherial contract.

**Polygon Mainnet** - [MetaStorage.sol](https://polygonscan.com/address/0xEA24e80e4B7A22C2226F9730465Ca07Bc6d5Ab81)<br>
**Mumbai Testnet** - [MetaStorage.sol](https://mumbai.polygonscan.com/address/0x971173863a52552D25aFC726984bAb3E01F7019B)

Metastorage is responsible for all event emissions and writing to the graph. Any and all cuts pertaining to metapass would be stored in this contract.

**Polygon Mainnet** - [MetapassFactory.sol](https://polygonscan.com/address/0x6B4ab842871C82596e3e1283aF8bCf1Be63aA5EA)<br>
**Mumbai Testnet** - [MetapassFactory.sol](https://mumbai.polygonscan.com/address/0x33dB244e8Ccbc1f9dc9291A1B929475c7c85361e)

Factory contract which generates instance of new event.
