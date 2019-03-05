require_relative "base"

module Suspenders
  class StylesheetBaseGenerator < Generators::Base
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

    def install_normalize_css
      run "bin/yarn add normalize.css"
    end
  end
end
