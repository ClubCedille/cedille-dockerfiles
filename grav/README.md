# Image Docker pour Grav CMS

Ce répertoire contient un Dockerfile personnalisé conçu pour déployer une instance Grav CMS avec un thème squelette spécifié. C'est la solution standardisée que nous offrons aux autres clubs étudiants souhaitant héberger leur site web chez nous.

## Utilisation
Pour utiliser cette configuration, suivez les étapes ci-dessous :

### Construire les Images Docker

1. Construire l'Image du Conteneur d'Initilisation (grav-init): Ce conteneur est responsable de la préparation du squelette du thème Grav choisi.

```bash
cd ./init-grav
docker build -t grav-init .
```

2. Construire l'Image Principale de Grav CMS: Cette image contient le CMS Grav. À partir du dossier grav, exécuter : 
```bash
docker build --build-arg GRAV_SKELETON_URL=<VOTRE_URL> -t grav .
```

### Docker Compose

Utilisez docker-compose pour lancer les conteneurs :
```bash
docker-compose up --build
```

