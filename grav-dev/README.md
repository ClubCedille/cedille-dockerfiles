# Grav-dev

## Développement Local

Pour développer localement avec un repertoire git désiré, vous pouvez utiliser
compose avec la commande suivante :

```bash
docker-compose up --build
```

Cette configuration :

- Clone le repo à synchroniser (e.g.,
  <https://github.com/ClubCedille/raconteurs.etsmtl.ca.git>)
- Monte le contenu dans `./content` pour modification
- Crée un utilisateur admin local (admin/admin123)
- Démarre le serveur sur <http://localhost:8080>

**Note**: Les modifications dans `./content` seront persistantes.
