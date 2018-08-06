require "rails/generators"

module Suspenders
  class CiGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__))

    def setup_gitlab_ci
      template 'gitlab-ci.yml.erb', '.gitlab-ci.yml'
    end

    def copy_database_yml_for_gitlab
      copy_file 'database.gitlab.yml', 'config/database.gitlab.yml'
    end
  end
end
