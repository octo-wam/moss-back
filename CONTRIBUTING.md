# Politique de Contribution

Moss est né en novembre 2019, au cours du Kick-off de la "League WAM".

Tous les Octos peuvent participer au développement de Moss Back, tant que les développements sont validés et relus par l'équipe du projet.

Voici quelques règles de développement qui sont pour la plupart des standards chez OCTO Technology.

## Règles générales

### Consulter les boards

Le [Projet Github](https://github.com/octo-wam/moss-back/projects/1) liste un grand nombre de tâches à réaliser, ainsi que la page des Issues.

Avant de partir sur un sujet, il est important d'en discuter avec l'équipe du projet pour s'assurer que le besoin est toujours existant et avoir quelques pistes pour démarrer les développements.

### Créer et publier une branche

Au début des développements, il faut créer une _feature-branch_ (`git branch -d ma-nouvelle-fonctionnalite`), sur laquelle commiter des changements.

Avant d'envoyer du code sur le serveur distant (`git push`), il faut penser à lancer les tests automatisés (cf ci-dessous) pour s'assurer qu'il n'y a aucune régression. Et, bien sûr, réparer les tests qui échouent.

Une fois la branche poussée sur le serveur distant, il faut [créer une Pull Request](https://github.com/octo-wam/moss-back/compare) sur GitHub. Cela crée notamment une pipeline de tests automatisés (CI) et permet à la team Moss Back de relire le code écrit (code review).
 
 Une fois la Pull Request validée et recettée par la team, elle sera mergée sur master puis mise en production.
  
## Tests automatisés

### Rspec

Nous utilisons principalement Rspec pour les test automatisés qui sont situés dans le dossier `spec/`. Pour les lancer :

```shell script
# Tous les tests
rspec
# Seulement un fichier
rspec spec/models/user_spec.rb
```

Toute nouvelle méthode en Ruby doit être accompagnée d'un test en Rspec. Tout fichier `xxx.rb` dans le dossier `app` doit avoir son équivalent `xxx_spec.rb` dans le dossier `spec/`.

#### BDD de test

Rspec utilise un schéma de base de données pour effectuer une partie de ses tests.

Les commandes `rails db:*` agissent à la fois sur la base de données locale et celle des tests. Mais vous pouvez agir uniquement sur celle des tests si besoin :

```shell script
# Supprimer la base de tests
rails db:drop RAILS_ENV=test

# Recréer la base de tests et jouer les migrations
rails db:create RAILS_ENV=test
rails db:migrate RAILS_ENV=test

# Annuler la dernière migration
rails db:rollback RAILS_ENV=test
```

### Rubocop

Rubocop est un linter de code Ruby, pour homogénéiser la façon de coder dans le projet. Les règles sont configurées dans `.rubocop.yml`.

- `rubocop` : Permet de détecter les irrégularités
- `rubocop -a` : Permet de corriger automatiquement celles qui peuvent l'être

La commande `rubocop --auto-gen-config` permet de mettre de côté certaines remarques "pour plus tard" dans un fichier `.rubocop_todo.yml`. Mais c'est un peu mettre la poussière sous le tapis !
