require_relative "base"

module Suspenders
  class LintGenerator < Generators::Base
    def add_linters_gems
      gem 'rubocop', '~> 0.71.0', require: false, group: :development
      gem 'rubocop-performance', require: false, group: :development
      gem 'rubocop-rails', require: false, group: :development
      gem 'rubocop-rspec', require: false, group: :development
      gem 'slim_lint', require: false, group: :development
      gem 'overcommit', '>= 0.48.1', require: false, group: :development
      gem 'rubycritic', require: false, group: :development

      # FIXME: switch back to bundle install once https://github.com/sds/overcommit/pull/649
      # will be merged
      Bundler.with_clean_env { run "bundle update" }
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
