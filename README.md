# Terracraft

Serveur Minecraft Java **survie**  déployé sur Coolify depuis ce repo. Aucune intervention manuelle de la rédaction du fichier de config au déploiment : pipeline 100% agentique IA.

| | |
|---|---|
| Adresse du serveur | `terracraft.aniss.xyz` |
| Version | Minecraft Java **26.3** (Paper) |
| Carte web 3D | https://terracraft.aniss.xyz |
| Difficulté | Normal, whitelist active |

## Pour les joueurs

1. Lancer Minecraft Java en **26.3**, Multijoueur > Ajouter un serveur > `terracraft.aniss.xyz`.
2. **Chat vocal de proximité (optionnel mais conseillé)** : installer [Fabric](https://fabricmc.net/use/installer/) pour 26.3, puis déposer dans le dossier `mods` :
   - [Simple Voice Chat](https://modrinth.com/plugin/simple-voice-chat) (version Fabric 26.3)
   - [Fabric API](https://modrinth.com/mod/fabric-api)
   Touche `V` pour les réglages, micro en push-to-talk ou activation vocale.
   Sans le mod, on peut jouer normalement, juste sans voix.

### Commandes utiles

| Commande | Effet |
|---|---|
| `/sethome [nom]` | Définit un point de retour (3 max par joueur) |
| `/home [nom]` | Se téléporte à son home |
| `/delhome <nom>` | Supprime un home |
| `/tpa <joueur>` | Demande à se téléporter vers un joueur |
| `/tpahere <joueur>` | Demande à un joueur de venir à soi |
| `/tpaccept` / `/tpdeny` | Accepte / refuse une demande |
| `/back` | Retour au dernier point avant téléportation |

La nuit passe dès que **50 % des joueurs connectés** dorment.

## Ce qui tourne

- **Paper 26.3** avec flags JVM Aikar, view distance 10, simulation distance 8, explosions optimisées.
- **Plugins** (auto-téléchargés au démarrage) :
  - [EssentialsX](https://essentialsx.net) : `/home`, `/tpa`, `/back` (kit de départ désactivé pour rester vanilla)
  - [LuckPerms](https://luckperms.net) : permissions des commandes ci-dessus pour tous les joueurs
  - [BlueMap](https://bluemap.bluecolored.de) : carte web 3D
  - [Simple Voice Chat](https://modrepo.de/minecraft/voicechat/overview) : chat vocal de proximité
  - [Chunky](https://modrinth.com/plugin/chunky) : pré-génération du monde (moins de lag en exploration)
- **Sauvegardes** (conteneur `backups`) : toutes les 12 h si quelqu'un a joué, conservées 5 jours, compressées zstd, dans le volume `mc-backups`.

## Administration

### Variables Coolify (Environment Variables)

| Variable | Rôle |
|---|---|
| `WHITELIST` | Pseudos autorisés, séparés par des virgules. Les ajouts sont fusionnés à chaque redémarrage. |
| `OPS` | Pseudos administrateurs |
| `MEMORY` | RAM JVM (défaut `6G`, la VM a 11 Go) |
| `SERVICE_PASSWORD_RCON` | Généré par Coolify, ne pas toucher |

Après modification : **Redeploy** dans Coolify.

### Console serveur

Coolify > Terracraft > Terminal > conteneur `mc`, puis :

```sh
rcon-cli                       # console interactive
rcon-cli whitelist add Pseudo  # exemple de commande directe
```

Pré-génération (déjà lancée au premier déploiement) : `chunky radius 2500` puis `chunky start`, suivi avec `chunky progress`.

### Réseau (Bbox)

Redirections NAT/PAT vers la VM Coolify `192.168.1.3` :

| Port | Protocole | Usage |
|---|---|---|
| 25565 | TCP | Minecraft |
| 24454 | UDP | Chat vocal |

La carte web passe par le proxy Coolify (ports 80/443 déjà ouverts).

### Mise à jour de version

1. Attendre que Paper et les plugins supportent la nouvelle version (vérifier sur https://papermc.io/downloads/paper et Modrinth).
2. Changer `VERSION` dans `docker-compose.yml`, push, Redeploy. Une sauvegarde manuelle avant est recommandée.
3. Si Paper publie des builds **STABLE** pour la version, retirer `PAPER_CHANNEL: experimental`.
4. EssentialsX est épinglé sur une build dev : remplacer l'URL `PLUGINS` par la release stable quand elle supporte la version.

### Restaurer une sauvegarde

1. Stopper le service dans Coolify.
2. Dans le terminal du serveur : repérer le volume `*_mc-backups`, extraire l'archive voulue (`tar --zstd -xf ...`) dans le volume `*_mc-data`.
3. Redémarrer.

### Réglages Paper

Paper corrige certains bugs vanilla (duplication TNT/rails/tapis, etc.). Pour les réactiver, voir `config/paper-global.yml` section `unsupported-settings`, ou ajouter les clés dans `patches.json`.
