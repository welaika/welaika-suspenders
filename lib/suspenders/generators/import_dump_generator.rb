require_relative "base"

module Suspenders
  class ImportDumpGenerator < Generators::Base
    def copy_script
      template "bin_import_dump.erb", "bin/import_dump"
      chmod "bin/import_dump", 0o755
    end

    def inform_user
      instructions = <<~MARKDOWN

        ## Importing a dump from Heroku

        If you have configured the heroku remotes successfully,
        you can import a fresh dump from staging or production with:

            % ./bin/import_dump staging
            % ./bin/import_dump production

        ## Resetting a database

        If you want to reset (destroy and recreate) a database on Heroku, you
        cannot use `heroku run rake db:drop`, instead use:

            % heroku pg:reset DATABASE_URL --remote=staging

        ( source: https://devcenter.heroku.com/articles/heroku-postgresql#pg-reset )

        Remeber to create a new backup schedule if you reset your database!

            % heroku pg:backups:schedule DATABASE_URL --at '2:00 UTC' --remote=staging

        ( source: https://devcenter.heroku.com/articles/heroku-postgres-backups#scheduling-backups )

      MARKDOWN

      append_file "README.md", instructions
    end
  end
end
