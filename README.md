# README

## Installing

- [Install rvm](https://rvm.io/rvm/install)
- Install ruby-2.7.2 : `rvm install "ruby-2.7.2"`
- Install bundler : `gem install bundler`
- Install postgres :
    - `brew install postgres`
    - start the postegres server just once : `pg_ctl -D /usr/local/var/postgres start` or start as a service : `brew services start postgresql`
    - `createuser -s -r postgres`
- Install dependencies : `bundle install`
- Run : `rails db:create` then `rails db:migrate`
- Create `.env` file from `.env.example` and fill the values thanks to a teammate

## Run linter

`rubocop`

## Run tests

`rspec`

Or :

`RUBYOPT='-W0' rspec` if there are Ruby 2.7 warnings

## Start server

`rails s`

## Se connecter avec Google

- Login: http://localhost:3000/auth/google_oauth2
- Callback:http://localhost:3000/auth/google_oauth2

## Swagger

La documentation de l'API, qui utilise Swagger, se trouve à l'URL /api/documentation.

### Générer le fichier de définition du Swagger

Ne pas modifier directement le fichier `swagger/v*/swagger.json` !

Générez-le avec la commande suivante : `rails rswag:specs:swaggerize`.

Ce fichier est généré sur la base des indications présentes dans les fichiers `spec/requests/api/v*/*_swagger_spec.rb`. Ces fichiers font donc office à la fois de définition Swagger et de tests automatisés, lancés via `rspec`.
