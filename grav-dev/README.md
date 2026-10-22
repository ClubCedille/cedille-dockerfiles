# Grav-dev

## Développement Local

Pour développer localement avec un repertoire git désiré, vous pouvez utiliser
compose avec la commande suivante :

```bash
docker-compose up --build
```

Cette configuration :

- Clone le repo directement dans `./content` (répertoire git complet)
- Monte le contenu dans `./content` pour modification
- Crée un utilisateur admin local (admin/admin123)
- Démarre le serveur sur <http://localhost:8080>

**Note**: Les modifications dans `./content` seront persistantes.

## Windows (CMD/PowerShell)

Si vous utilisez Docker sur Windows sans WSL2, `$UID` n'est pas disponible. Exécutez cette commande une seule fois :

```bash
git config --global --add safe.directory *
```

## Travailler avec le contenu (git)

Le dossier `./content` est un dépôt git complet. Vous pouvez y travailler directement :

```bash
cd content
git checkout -b ma-branche
# ... modifier des fichiers ...
git add pages/mon-article.md
git commit -m "Ajout article"
git push
```

## Fichiers gérés par Vault (ignorés localement)

En production, deux fichiers sont injectés par Vault et créés comme symlinks :

- `config/plugins/git-sync.yaml` — config du plugin GitSync (token GitHub)
- `config/security.yaml` — salt de sécurité Grav

En local, ces fichiers sont remplacés automatiquement par des valeurs fictives
au démarrage du conteneur. Ils sont marqués `skip-worktree` dans git pour ne
**pas** apparaître comme des changements et ne **pas** être accidentellement
commités.

Si vous devez réinitialiser ces fichiers (ex: après un `git pull` qui les écrase) :

```bash
docker-compose restart
```

Le conteneur les recréera automatiquement.
