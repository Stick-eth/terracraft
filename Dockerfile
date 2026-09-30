# Image de base : itzg/minecraft-server (Java 25, requis pour Minecraft 26.x)
FROM itzg/minecraft-server:stable-java25

# Fichiers synchronisés au démarrage vers /data/plugins (voir docs itzg "attach points")
COPY bluemap-core.conf /plugins/BlueMap/core.conf

# Patchs de config appliqués à chaque démarrage (PATCH_DEFINITIONS=/patches)
COPY patches.json /patches/patches.json
