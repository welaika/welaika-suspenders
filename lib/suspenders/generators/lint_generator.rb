require "rails/generators"

module Suspenders
  class LintGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_linters_gems
      gem 'rubocop', require: false, group: :development
      gem 'rubocop-rspec', require: false, group: :development
      gem 'slim_lint', require: false, group: :development
      Bundler.with_clean_env { run "bundle install" }
    end

    def setup_rubocop
      copy_file "rubocop.rake", "lib/tasks/rubocop.rake"
      copy_file "rubocop.yml", ".rubocop.yml"
      copy_file "rubocop_todo.yml", ".rubocop_todo.yml"
    end

    def setup_slim_lint
      copy_file "slim-lint.rake", "lib/tasks/slim-lint.rake"
      copy_file "slim-lint.yml", ".slim-lint.yml"
    end

    def create_binstubs
      bundle_command "binstubs rubocop"
      bundle_command "binstubs slim_lint"
    end
  end
end
