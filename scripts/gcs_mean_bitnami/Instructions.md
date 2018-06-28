# Google Cloud MEAN stack (Bitnami) LND instalation

This script is tested on Google Cloud Services MEAN stack by Bitnami

## Getting Started

This is a full installer! It will install full bitcoin node, a lightning node and lightning-charge which is a lightning API.

### Prerequisites

You need to have MEAN stack server by Bitnami deployed on Google Cloud Services, with port 9735 open.

## Instalation

Simply follow these steps

First step

```
Edit the values in config file (This is for your Lightning Node)
```

Second step

```
Install by running ./install.sh
```

#### Now wait for about 12+ hours for bitcoin node to fully sync.

To check bitcoin node syncing progress use

```
tail -f ~/.bitcoin/debug.log
```

After bitcoin node is fully synced use this command to start your lightning node and lightning charge

```
immortal lightningd
immortal charged --api-token mySecretToken --db-path ~/chargedb/charge.db
```
