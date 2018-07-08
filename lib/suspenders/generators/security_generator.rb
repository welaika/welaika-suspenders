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


    def setup_brakeman
      copy_file "brakeman.rake", "lib/tasks/brakeman.rake"
    end

    def setup_bundler_audit
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
    end

    def create_binstubs
      Bundler.with_clean_env { run "bundle binstubs brakeman" }
    end
  end
end
