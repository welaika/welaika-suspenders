require "rails/generators"

module Suspenders
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_slim_gem
      gem "slim-rails"
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_slim
      copy_file 'slim.rb', 'config/initializers/slim.rb'
    end

    def create_partials_directory
      empty_directory "app/views/application"
    end

    def create_shared_flashes
      copy_file "_flashes.html.slim", "app/views/application/_flashes.html.slim"
      copy_file "flashes_helper.rb", "app/helpers/flashes_helper.rb"
    end

    def create_shared_javascripts
      copy_file "_javascript.html.slim",
        "app/views/application/_javascript.html.slim"
    end

    def create_shared_css_overrides
      copy_file "_css_overrides.html.slim",
        "app/views/application/_css_overrides.html.slim"
    end

    def create_application_layout
      template "suspenders_layout.html.slim.slim",
        "app/views/layouts/application.html.slim",
        force: true
    end
  end
end
