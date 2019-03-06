require "rails/generators"

module Suspenders
  class SecurityGenerator < Generators::Base
    def add_checkers_gems
      gem 'brakeman', require: false, group: :development
      gem 'bundler-audit', '>= 0.5.0', require: false, group: :development
      Bundler.with_clean_env { run "bundle install" }
    end

    def create_binstubs
      Bundler.with_clean_env do
        run "bundle binstubs brakeman"
        run "bundle binstubs bundler-audit"
      end
    end
  end
end
