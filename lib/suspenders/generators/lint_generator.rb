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
      gem 'overcommit', require: false, group: :development
      gem 'rubycritic', require: false, group: :development
      Bundler.with_clean_env { run "bundle install" }
    end

    def setup_rubocop
      copy_file "rubocop.yml", ".rubocop.yml"
      copy_file "rubocop_todo.yml", ".rubocop_todo.yml"
    end

    def setup_slim_lint
      copy_file "slim-lint.yml", ".slim-lint.yml"
    end

    def setup_overcommit
      run "overcommit --install"
      copy_file "overcommit.yml", ".overcommit.yml", force: true
      run "overcommit --sign"
    end

    def setup_rubycritic
      copy_file "reek", ".reek"
    end

    def create_binstubs
      Bundler.with_clean_env do
        run "bundle binstubs rubocop"
        run "bundle binstubs slim_lint"
        run "bundle binstubs overcommit"
        run "bundle binstubs rubycritic"
      end
    end
  end
end
