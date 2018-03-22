# docker-cryplyd
Dockerfile for Cryply Core (https://github.com/cryply/cryply-wallet)

# Example Usage

## Starting Cryply Core
```
$ docker run -it -v $(pwd)/data:/data -p 48887:48887 --name=cryplyd mecab/cryplyd
```

## Interacting with the Daemon
```
$ docker exec cryplyd cryply-cli -datadir=/data getinfo
```

# Data Persistent
You should persist your data, which is normally (if without container) created as `~/.cryply`, by specify `-v` option to map host directory to `datadir` inside the container (e.g., `-v $(pwd)/data:/data`).
Note we pass `-datadir=/data` by default, but if you override the arguments you will need to add it manually.
 (e.g. `docker run -it -v $(pwd)/data:/data mecab/cryplyd -datadir=/data -testnet=3`)

Do persist. Not to persist means not to persist your wallet. If you didn't persist your data, your wallet is saved on somewhere deeper [^1] in your disk and will be removed when you remove the container.

[^1]: If you know where it is, you are not Docker beginner, no need to explain.


