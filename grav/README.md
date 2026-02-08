# Image Docker pour Grav CMS

Ce répertoire contient un Dockerfile pour déployer une instance Grav CMS. C'est
la solution standardisée que nous offrons aux autres clubs étudiants souhaitant
héberger leur site web chez nous.

## Construire l'image

Par défaut, l'image utilise le package Grav Admin de base :

```bash
docker build -t grav .
```

Pour utiliser un squelette (skeleton) différent, passer l'URL en build arg :

```bash
docker build \
  --build-arg GRAV_SKELETON_URL=https://github.com/getgrav/grav-skeleton-gateway-site/releases/download/1.0.1/grav-skeleton-gateway-site+admin-1.0.1.zip \
  -t grav .
```

Les squelettes disponibles se trouvent sur
[getgrav.org/downloads/skeletons](https://getgrav.org/downloads/skeletons). On
recommande de choisir un squelette avec l'admin intégré pour faciliter la
gestion du site (regarder pour les thèmes avec l'option `Download with admin`).
Rendez vous sur le repo github du squelette pour trouver l'URL du package zip à
utiliser.

## Test local avec Docker Compose

```bash
docker compose up --build

# Squelette personnalisé
GRAV_SKELETON_URL="https://github.com/getgrav/grav-skeleton-gateway-site/releases/download/1.0.1/grav-skeleton-gateway-site+admin-1.0.1.zip" \
docker compose up --build
```

Le site est accessible sur `http://localhost:8080`.

> **Note :** Pour changer de squelette, supprimer le volume Docker au préalable
> :
> ```bash
> docker compose down -v
> ```
> Sinon l'ancien contenu persiste dans le volume.

## Déploiement en production (Kubernetes)

En production, l'image est déployée avec Vault pour un workflow automatisé/sécurisé.
L'entrypoint clone le contenu du site depuis un dépôt Git et configure les
comptes utilisateurs depuis Vault.

Variables d'environnement utilisées en production :
- `GIT_VAULT_SECRET` : nom du secret Vault contenant la config git-sync
- `ADMIN_VAULT_SECRET` : nom du secret Vault pour le compte admin
- `SRE_VAULT_SECRET` : nom du secret Vault pour le compte SRE
- `HEAD_BRANCH` : branche Git à utiliser (défaut : `main`)
