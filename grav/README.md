# Image Docker pour Grav CMS

Ce répertoire contient un Dockerfile personnalisé conçu pour déployer une instance Grav CMS avec un thème squelette spécifié. C'est la solution standardisée que nous offrons aux autres clubs étudiants souhaitant héberger leur site web chez nous.

## Utilisation

Pour construire l'image Docker Grav avec une URL de squelette spécifique:

```bash
docker build --build-arg GRAV_SKELETON_URL=<VOTRE_URL> -t <NOM_DE_VOTRE_IMAGE> .
```
