require "rails/generators"

module Suspenders
  class DecoratorGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_draper_gem
      gem "draper"
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_draper
      generate "draper:install", "--force"
    end
  end
end
