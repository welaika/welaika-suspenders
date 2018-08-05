require "rails/generators"

module Suspenders
  class SecurityGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_checkers_gems
      gem 'brakeman', require: false, group: :development
      gem 'bundler-audit', '>= 0.5.0', require: false, group: :development
      Bundler.with_clean_env { run "bundle install" }
    end

    def create_binstubs
      Bundler.with_clean_env { run "bundle binstubs brakeman" }
    end
  end
end
