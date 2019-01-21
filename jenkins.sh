[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

gem install bundler

rvm use ruby-2.5.1@binance_client

gem update --system

bundle install

#read -d '' database_yml <<"EOF"
#test:
#  adapter: postgresql
#  encoding: unicode
#  database: wrking_test
#  user: jenkins
#  pool: 5
#EOF

#echo "$database_yml" > config/database.yml

#rake db:test:prepare RAILS_ENV=test

#rake ci:setup:rspec spec RAILS_ENV=test

cp .env.example .env

rspec