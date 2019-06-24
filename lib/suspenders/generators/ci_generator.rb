require_relative "base"

module Suspenders
  class CiGenerator < Generators::Base
    def configure_ci
      template 'gitlab-ci.yml.erb', '.gitlab-ci.yml'
      template 'Dockerfile.gitlab.erb', 'Dockerfile.gitlab'
      copy_file 'database.gitlab.yml', 'config/database.gitlab.yml'
      copy_file 'dockerignore', '.dockerignore'
    end
  end
end
