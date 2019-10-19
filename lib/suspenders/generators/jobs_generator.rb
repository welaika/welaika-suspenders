require_relative "base"

module Suspenders
  class JobsGenerator < Generators::Base
    def add_jobs_gem
      gem "sidekiq"
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_foreman
      append_to_file(
        'Procfile',
        'worker: bundle exec sidekiq -C config/sidekiq.yml'
      )
    end

    def configure_sidekiq
      copy_file(
        "config_sidekiq.yml",
        "config/sidekiq.yml"
      )
    end

    def configure_sidekiq_web
      inject_into_file(
        "config/routes.rb",
        "require 'sidekiq/web'\n\n",
        before: "Rails.application.routes.draw do\n"
      )
      inject_into_file(
        "config/routes.rb",
        "  mount Sidekiq::Web => '/sidekiq'\n",
        after: "Rails.application.routes.draw do\n"
      )
      warn "Sidekiq web is public! Read https://github.com/mperham/sidekiq/wiki/Monitoring to learn how to add authentication"
    end

    def configure_sidekiq_test
      copy_file(
        "spec_support_sidekiq.rb",
        "spec/support/sidekiq.rb"
      )
    end

    def configure_active_job
      inject_into_file(
        "config/application.rb",
        "\n    config.active_job.queue_adapter = :sidekiq",
        before: "\n  end",
      )
    end
  end
end
