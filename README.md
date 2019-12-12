# README

## Installing

- [Install rvm](https://rvm.io/rvm/install)
- Install ruby-2.6.5 : `rvm install "ruby-2.6.5"`
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

## Start server

`rails s`

## Google Auth

http://localhost:3000/auth/google_oauth2/callback
