## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

# Contract Address

## Mantle

- Config = 0x72f6897062E719409418417209F51645fFA8022B
- MatchMaking = 0x62125dB2DA783f390CcE30cc354f97c316C62208
- FootballPlayer = 0x09700340Bd776602Be637c0Ff2F8b8C10E0d34E8
- PlayerConfig = 0x04bCD5E330ffcc9eFE9040Ae5170ed195d390D1e
- Manager = 0x9758163C44D813FEc380798A11CCf4531A3Fa3D3

## Scroll

- Config = 0x377DC7E60EF30Bce0a98bE68a1E1436f2fe4f58B
- MatchMaking = 0xb00E46C03Aa321499339C67dBc7F32D884ebC7eE
- FootballPlayer = 0x592e66eC7073d2a71a01470daA9D5556AE284549
- PlayerConfig = 0xD35C1e9975fB67c9658D7776426728920c5fD4F9
- Manager = 0xcbCC16386667432f6aA654723c2EBBc7fe336EAD
