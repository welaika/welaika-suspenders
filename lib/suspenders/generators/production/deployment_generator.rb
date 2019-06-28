require_relative "../base"

module Suspenders
  module Production
    class DeploymentGenerator < Generators::Base
      def copy_script
        copy_file "bin_deploy", "bin/deploy"
        chmod "bin/deploy", 0o755
      end

      def inform_user
        instructions = <<~MARKDOWN

          ## Deploying

          If you have previously run the `./bin/setup` script,
          you can deploy to staging and production with:

              % ./bin/deploy staging
              % ./bin/deploy -f staging # pushing with force-with-lease, attention!
              % ./bin/deploy production
              % ./bin/deploy -f production # pushing with force-with-lease, attention!
        MARKDOWN

        append_file "README.md", instructions
      end
    end
  end
end
