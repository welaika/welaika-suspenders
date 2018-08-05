module Suspenders
  module Adapters
    class Heroku
      def initialize(app_builder)
        @app_builder = app_builder
      end

      def set_heroku_remotes
        remotes = <<~SHELL
          echo "\n== Adding Heroku remotes =="
          #{command_to_join_heroku_app('staging')}
          #{command_to_join_heroku_app('production')}

          echo "\n== Setting default heroku remote to 'staging' =="
          git config heroku.remote staging
        SHELL

        app_builder.append_file "bin/setup", remotes
      end

      def create_staging_heroku_app(flags)
        app_name = heroku_app_name_for("staging")

        run_toolbelt_command "create #{app_name} #{flags}", "staging"
      end

      def create_production_heroku_app(flags)
        app_name = heroku_app_name_for("production")

        run_toolbelt_command "create #{app_name} #{flags}", "production"
      end

      def set_heroku_rails_secrets
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add SECRET_KEY_BASE=#{generate_secret}",
            environment,
          )
        end
      end

      def set_heroku_error_reporting_env
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add SENTRY_ENV=#{environment}",
            environment,
          )
        end
      end

      def set_heroku_backup_schedule
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "pg:backups:schedule DATABASE_URL --at '10:00 UTC'",
            environment,
          )
        end
      end

      def create_review_apps_setup_script
        app_builder.template(
          "bin_setup_review_app.erb",
          "bin/setup_review_app",
          force: true,
        )
        app_builder.run "chmod a+x bin/setup_review_app"
      end

      def create_heroku_application_manifest_file
        app_builder.template "app.json.erb", "app.json"
      end

      def create_heroku_pipeline
        pipelines_plugin = `heroku help | grep pipelines`
        if pipelines_plugin.empty?
          puts "You need heroku pipelines plugin. Run: brew upgrade heroku-toolbelt"
          exit 1
        end

        run_toolbelt_command(
          "pipelines:create #{heroku_app_name} \
            -a #{heroku_app_name}-staging --stage staging",
          "staging",
        )

        run_toolbelt_command(
          "pipelines:add #{heroku_app_name} \
            -a #{heroku_app_name}-production --stage production",
          "production",
        )
      end

      def set_heroku_application_host
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add APPLICATION_HOST=#{heroku_app_name}-#{environment}.herokuapp.com",
            environment,
          )
        end
      end

      def set_heroku_metadata_for_sentry
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "labs:enable runtime-dyno-metadata",
            environment
          )
        end
      end

      def set_buildpacks
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "buildpacks:add --index 1 heroku/nodejs",
            environment
          )
          run_toolbelt_command(
            "buildpacks:add --index 2 heroku/ruby",
            environment
          )
        end
      end

      private

      attr_reader :app_builder

      def command_to_join_heroku_app(environment)
        heroku_app_name = heroku_app_name_for(environment)
        <<~SHELL

          if heroku apps | grep #{heroku_app_name} > /dev/null 2>&1; then
            git remote add -f #{environment} git@heroku.com:#{heroku_app_name}.git || true
          else
            echo "** Ask for access to the '#{heroku_app_name}' Heroku app and run this script again **"
          fi
        SHELL
      end

      def heroku_app_name
        app_builder.app_name.dasherize
      end

      def heroku_app_name_for(environment)
        "#{heroku_app_name}-#{environment}"
      end

      def generate_secret
        SecureRandom.hex(64)
      end

      def run_toolbelt_command(command, environment)
        app_builder.run(
          "heroku #{command} --remote #{environment}",
        )
      end
    end
  end
end
