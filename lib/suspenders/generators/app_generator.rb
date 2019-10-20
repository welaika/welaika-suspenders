require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Suspenders
  class AppGenerator < Rails::Generators::AppGenerator
    hide!

    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :heroku, type: :boolean, aliases: "-H", default: false,
      desc: "Create staging and production Heroku apps"

    class_option :heroku_flags, type: :string, default: "--region eu",
      desc: "Set extra Heroku flags"

    class_option :version, type: :boolean, aliases: "-v", group: :suspenders,
      desc: "Show Suspenders version number and quit"

    class_option :help, type: :boolean, aliases: '-h', group: :suspenders,
      desc: "Show this help message and quit"

    class_option :path, type: :string, default: nil,
      desc: "Path to the gem"

    class_option :skip_test, type: :boolean, default: true,
      desc: "Skip Test Unit"

    class_option :skip_system_test,
                 type: :boolean, default: true, desc: "Skip system test files"

    class_option :skip_turbolinks,
                 type: :boolean, default: true, desc: "Skip turbolinks gem"

    class_option :skip_spring, type: :boolean, default: true,
                 desc: "Don't install Spring application preloader"

    def finish_template
      invoke :suspenders_customization
      super
    end

    def suspenders_customization
      invoke :customize_gemfile
      invoke :setup_development_environment
      invoke :setup_production_environment
      invoke :setup_secret_token
      invoke :configure_app
      invoke :copy_miscellaneous_files
      invoke :customize_error_pages
      invoke :setup_dotfiles
      invoke :setup_database
      invoke :generate_default
      invoke :setup_default_directories
      invoke :create_heroku_apps
      invoke :generate_deployment_default
      invoke :remove_config_comment_lines
    end

    def customize_gemfile
      build :replace_gemfile, options[:path]
      bundle_command 'install'
      bundle_command 'binstubs bundler --force'
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :use_postgres_config_template
      end

      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :configure_local_mail
      build :raise_on_missing_assets_in_test
      build :raise_on_delivery_errors
      build :set_test_delivery_method
      build :raise_on_unpermitted_parameters
      build :provide_setup_script
      build :configure_generators
      build :configure_i18n_for_missing_translations
      build :configure_quiet_assets
    end

    def setup_production_environment
      say 'Setting up the production environment'
      build :enable_rack_canonical_host
      build :enable_rack_deflater
      build :setup_asset_host
    end

    def setup_secret_token
      say 'Moving secret token out of version control'
      build :setup_secret_token
    end

    def configure_app
      say 'Configuring app'
      build :configure_action_mailer
      build :configure_locales_and_time_zone
      build :configure_time_formats
      build :configure_sourcemaps_for_sass
      build :setup_rakefile
      build :replace_default_puma_configuration
      build :set_up_forego
      build :setup_rack_mini_profiler
    end

    def create_heroku_apps
      if options[:heroku]
        say "Creating Heroku apps"
        build :create_heroku_apps, options[:heroku_flags]
        build :set_heroku_remotes
        build :set_heroku_rails_secrets
        build :set_heroku_application_host
        build :set_heroku_auto_migrate
        build :set_heroku_backup_schedule
        build :set_heroku_sentry_configuration
        build :set_heroku_smtp_settings
        build :set_heroku_buildpacks
        build :create_heroku_pipeline
        build :configure_automatic_deployment
      end
    end

    def setup_dotfiles
      build :copy_dotfiles
    end

    def setup_default_directories
      build :setup_default_directories
    end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_miscellaneous_files
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_config_comment_lines
      build :remove_config_comment_lines
    end

    def generate_default
      generate("suspenders:json")
      generate("suspenders:static")
      generate("suspenders:stylesheet_base")
      generate("suspenders:testing")
      generate("suspenders:ci")
      generate("suspenders:js_driver")
      generate("suspenders:db_optimizations")
      generate("suspenders:factories")
      generate("suspenders:lint")
      generate("suspenders:stylelint")
      generate("suspenders:decorator")
      generate("suspenders:faker")
      generate("suspenders:security")
      generate("suspenders:import_dump")
      generate("suspenders:jobs")
      generate("suspenders:inline_svg")
    end

    def generate_deployment_default
      generate("suspenders:staging:pull_requests")
      generate("suspenders:production:force_tls")
      generate("suspenders:production:email")
      generate("suspenders:production:timeout")
      generate("suspenders:production:error_reporting")
      generate("suspenders:production:deployment")
      generate("suspenders:production:manifest")
    end

    def generate_views
      generate("suspenders:views")
    end

    def generate_autoprefixer
      generate("suspenders:autoprefixer")
    end

    def generate_outro
      build :run_rubocop_autocorrect

      say "Congratulations! You just pulled our suspenders."
      say "Read README.md!"
    end

    def self.banner
      "welaika-suspenders #{arguments.map(&:usage).join(' ')} [options]"
    end

    protected

    def get_builder_class
      Suspenders::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
