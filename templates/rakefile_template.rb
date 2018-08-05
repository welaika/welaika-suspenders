# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks
task(:default).clear

desc 'Run linters, quality, security and tests'
task :default do
  sh 'bundle exec rubocop'
  sh 'bundle exec rubycritic app/ config/ lib/ --no-browser --minimum-score 94 --format console'
  sh 'bundle exec bundle-audit check --update'
  sh 'bundle exec brakeman -z'
  sh 'bundle exec rake factory_lint'
  sh 'bundle exec rails db:migrate RAILS_env=test'
  sh 'bundle exec rspec spec/'
end
