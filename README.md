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

## Google Auth

- Login: http://localhost:3000/auth/google_oauth2
- Callback:http://localhost:3000/auth/google_oauth2