# Terracraft

Serveur Minecraft Java en Docker Compose.

## Stack

- Minecraft Java **26.3**, serveur [Paper](https://papermc.io) via [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server) (Java 25, flags Aikar)
- Plugins téléchargés au démarrage : EssentialsX, LuckPerms, BlueMap, Simple Voice Chat, Chunky
- Sauvegardes : [itzg/mc-backup](https://github.com/itzg/docker-mc-backup) (tar zstd, rotation)

## Ports

| Port | Protocole | Usage |
|---|---|---|
| 25565 | TCP | Minecraft |
| 24454 | UDP | Simple Voice Chat |
| 8100 | TCP | BlueMap (interne, derrière reverse proxy) |

## Variables d'environnement

| Variable | Défaut | Rôle |
|---|---|---|
| `MEMORY` | `6G` | Heap JVM |
| `WHITELIST` | vide | Pseudos autorisés (séparés par des virgules) |
| `OPS` | vide | Pseudos opérateurs |
| `MOTD` | `Terracraft` | Message du serveur |
| `TZ` | `UTC` | Fuseau horaire |
| `SERVICE_PASSWORD_RCON` | généré | Mot de passe RCON partagé avec le conteneur de sauvegarde |

## Fichiers

- `docker-compose.yml` : services `mc` et `backups`
- `Dockerfile` : image de base + configs embarquées
- `patches.json` : patchs de config appliqués au démarrage (EssentialsX, Paper)
- `bluemap-core.conf` : config BlueMap
