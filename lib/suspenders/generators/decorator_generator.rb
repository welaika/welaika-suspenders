require "rails/generators"

module Suspenders
  class DecoratorGenerator < Generators::Base
    def add_draper_gem
      gem "draper"
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_draper
      generate "draper:install", "--force"
    end
  end
end
