# frozen_string_literal: true

namespace :factory_bot do
  desc 'Verify that all FactoryBot factories are valid'
  task lint: :environment do
    if Rails.env.test?
      require 'database_cleaner'

      sh 'bundle exec rails db:migrate'
      DatabaseCleaner.clean_with :truncation
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.cleaning do
        FactoryBot.lint(traits: true)
      end
    else
      system('bundle exec rake factory_bot:lint RAILS_ENV=test')
      raise if $CHILD_STATUS.exitstatus.nonzero?
    end
  end
end
