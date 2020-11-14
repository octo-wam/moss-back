# Mise en production

## Environnements

Moss Back possède deux environnements, hébergés sur Heroku. L'accès aux panels d'administration Heroku est à demander à la team Moss.

### Demo
- Identifiant Heroku : octo-moss-back-demo
- URL de l'application : https://octo-moss-back-demo.herokuapp.com
- Panel d'admin : https://dashboard.heroku.com/apps/octo-moss-back-demo

### Production
- Identifiant Heroku : octo-moss-back
- URL de l'application : https://octo-moss-back.herokuapp.com
- Panel d'admin : https://dashboard.heroku.com/apps/octo-moss-back

## Utiliser le CLI Heroku

Il est possible de faire des actions sur ces environnements en ligne de commande en utilisant le CLI Heroku.

Si vous avez Homebrew, vous pouvez installer le CLI comme ceci :

```shell script
brew tap heroku/brew && brew install heroku
```

Une fois installé, vous pouvez vous connecter à votre compte Heroku avec la commande suivante :

```shell script
heroku login
```

Par exemple, il est possible d'avoir accès aux logs de l'application :

```shell script
heroku logs -t -a octo-moss-back
```

## Déclencher les tâches à la main

Les rake tasks peuvent être déclenchées manuellement :

```shell script
heroku run rails ma_tache -a octo-moss-back-demo
```

## Configurer ses environnements git distants

Ajouter l'environnement de production dans vos remotes git :

```shell script
heroku git:remote --remote heroku-production -a octo-moss-back
```

Cela va ajouter un remote appelé `heroku-production`.

Il est possible de consulter la liste de ses environnements git distants avec la commande `git remote`, et consulter l'URL spécifique d'un environnement avec `git remote get-url heroku-production`.

## Déployer sur un environnement

_/!\ Le code déployé en production doit être du code qui a été mergé sur `origin/master`. Il faut penser à pousser d'abord sur GitHub, qui reste le référentiel, avant de mettre en production._

Une fois que tout est bien configuré, il est possible de déployer en faisant un simple `git push` :

```shell script
git push heroku-production master
```

Dans certains cas, il est nécessaire d'accompagner une mise en production d'une migration de la base de données (`rails db:migrate`) ou de certaines actions de migration spécifiques via les rake tasks (`rails ma_task_1`).

Il peut donc être intéressant de mettre l'application en mode maintenance, lancer ces actions, puis retirer le mode maintenance :

```shell script
git push heroku-production master && 
heroku maintenance:on -a octo-moss-back && 
heroku run rails db:migrate ma_task_1 ma_task2 -a octo-moss-back && 
heroku restart -a octo-moss-back && 
heroku maintenance:off -a octo-moss-back
```
