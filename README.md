Moss Back
========

## Introduction

Moss est l'outil de décision de la League WAM chez OCTO Technology.

Ce projet correspond à la partie API/back de l'application Moss, développée avec le framework Ruby on Rails.

Deux applications Moss consomment cette API :
- Une [application front-end](https://github.com/octo-wam/moss-front)
- Une [application Android](https://github.com/octo-wam/moss-android)

## Installation

Voir [INSTALLATION.md](INSTALLATION.md).

## Démarrer le serveur local

Pour démarrer le serveur, entrer la commande suivante :

```shell script
rails server
# ou
rails s
```

Si besoin de lancer une console :

```shell script
rails console
# ou
rails c
```

Pour se connecter à Google et recevoir un access_token API : http://localhost:3001/auth/google_oauth2

## Tests automatisés

Infos plus complètes sur [CONTRIBUTING.md](CONTRIBUTING.md).

Nous utilisons principalement Rspec pour les test automatisés qui sont situés dans le dossier `spec/`. Pour les lancer :

```shell script
rspec
# ou s'il y a des erreurs dues à Ruby 2.7
RUBYOPT='-W0' rspec
```

Nous nous appuyons également sur le linter Rubocop pour homogéniser le code style. Pour détecter des irrégularités :

```shell script
rubocop
```

Pour vérifier l'ensemble en une commande :

```shell script
rspec && rubocop
```

## Politique de Contribution

Voir [CONTRIBUTING.md](CONTRIBUTING.md).

## Mise en production

Voir [DEPLOY.md](DEPLOY.md).
