require "rails/generators"

module Suspenders
  class StylesheetBaseGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__))

    def add_stylesheet_gems
      gem "bourbon", "~> 5.0.0.beta.7"
      Bundler.with_clean_env { run "bundle install" }
    end

    def add_css_config
      copy_file(
        "application.sass",
        "app/assets/stylesheets/application.sass",
        force: true,
      )
    end

    def remove_prior_config
      remove_file "app/assets/stylesheets/application.css"
    end
  end
end
