# Installation

## Cloner le dépôt

Si vous avez bien renseigné une [clé SSH dans vos paramètres](https://github.com/settings/keys) GitHub, vous pouvez cloner le dépôt de Moss Back comme suit :

```shell script
git clone git@github.com:octo-wam/moss-back.git
```

## Installer Ruby et ses "gems"

Il faut tout d'abord installer la bonne version de Ruby.

Il est conseillé de l'installer via RVM (Ruby Version Manager) qui permet de gérer et installer facilement plusieurs versions du langage. [Lien d'installation de RVM](https://rvm.io/rvm/install).

Une fois RVM possédé, il faut donc installer la version de Ruby indiquée dans le fichier `Gemfile`. S'il s'agit de `ruby '2.7.2'` il faut alors lancer la commande suivante : `rvm install "ruby-2.7.2"`.

Enfin, il faut installer Ruby on Rails et les autres dépendances du projet (qui sont listées dans le fichier `Gemfile`). Cela se fait en deux étapes :
- Installer bundler pour gérer toutes les gems (dépendances) : `gem install bundler`
- Installer le reste des dépendances via bundler : `bundle install`

## Mettre en place une base de données

### a) Installer et démarrer PostgreSQL

PostgreSQL est le SGBD utilisé pour le projet. Il faut donc tout d'abord l'avoir installé sur sa machine.

Via Homebrew : `brew install postgres`

Une fois installé, il est possible de démarrer le démon postgres de deux manières :
- A la demande : `pg_ctl -D /usr/local/var/postgres start` (à refaire à chaque démarrage de la machine)
- En automatique : `brew services start postgresql` (sera toujours en fonctionnement tant qu'il n'est pas arrêté par `brew services stop postgresql`)

### b) Créer un utilisateur et le lier au projet

Il faut créer un premier utilisateur PostgreSQL pour accéder à cette base, ayant pour username `moss-user` et pour mot de passe celui que vous allez renseigner :

```shell script
# "-s" crée un superuser
# "-P" demande de renseigner un mot de passe
createuser -s -r moss-user -P
```

Ces username et mot de passe de base de données sont à renseigner dans un fichier `config/database.yml` qu'il faut créer en s'inspirant du fichier d'exemple `config/database.yml.example`.

### c) Mettre en place le schéma de base

Pour créer le schéma de base de données "moss" et effectuer les migrations qui sont dans le dossier `db/migrate/`, il faut lancer les deux commandes suivantes :

```shell script
rails db:create
rails db:migrate
```

Il est possible de remplir la base de données avec des données de test contenues dans `db/seeds.rb` :

```shell script
rails db:seed
```

## Variables d'environnement

Les variables d'environnement du projet (URLs, credentials, ...) sont à renseigner dans un fichier `.env` à la racine. Il est possible de créer ce fichier depuis le fichier .env.example.

```shell script
cp .env.example .env
```

Vous aurez besoin de remplir tout ou partie de ces variables d'environnement en fonction de ce que vous souhaiterez tester en local. Par exemple :
- Les variables GOOGLE_* pour utiliser la connexion Oauth2 Google
- Les variables MAILTRAP_* pour tester l'envoi d'e-mails
- La variable FRONT_BASE_URL qui indique l'URL du projet moss-front
- La variable SECRET_KEY_BASE pour qui va encoder l'access token API (voir ci-dessous)
- etc.

S'il vous manque une variable importante pour le développement, demandez-la à la team Moss.

Ce fichier `.env` est notamment lu par la library `dotenv-rails` (voir ci-dessous).

### Générer une clé secrète

Pour remplir la variable SECRET_KEY_BASE, vous pouvez générer une chaîne aléatoire de 64 caractères alphanumériques en passant par la console Rails :

```shell script
rails c
```

Dans la console Rails, vous pouvez effectuer des instructions Ruby :

```ruby
SecureRandom.hex(32)
# => 9a0253058823e04a7a9bfd06eb47e67287bf54f7cd0a5402db9986adbe877746
# Il suffit de copier cette string dans le fichier .env

# Pour quitter la console
quit
```

## Tout est en place !

Vous pouvez vérifier que les tests automatisés se lancent :

```shell script
rspec
```

Vous pouvez démarrer le serveur en local avec la commande ci-dessous puis voir la page d'accueil sur [http://localhost:3001](http://localhost:3001) (en fonction du port renseigné dans `.env`).

```shell script
rails server
# ou
rails s
```

## Se connecter avec Google

Pour se connecter à la plateforme, il faut que les variables GOOGLE_* soient renseignées dans le fichier `.env`.

Il faut ensuite cliquer sur ce lien : http://localhost:3001/auth/google_oauth2

Si vous avez une erreur "redirect_uri_mismatch", vérifiez que vous utilisez bien le port 3001 dans `.env` (seul port autorisé dans la console Google Oauth).

(L'URL de callback Google est : http://localhost:3000/auth/google_oauth2/callback)
