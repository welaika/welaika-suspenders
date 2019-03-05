require_relative "base"

module Suspenders
  class CiGenerator < Generators::Base
    def configure_ci
      template 'gitlab-ci.yml.erb', '.gitlab-ci.yml'
      copy_file 'database.gitlab.yml', 'config/database.gitlab.yml'
    end
  end
end
