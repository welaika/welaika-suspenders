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
      MARKDOWN

      append_file "README.md", instructions
    end
  end
end
