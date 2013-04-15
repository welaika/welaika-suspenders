module WelaikaSuspenders
  class AppBuilder < Rails::AppBuilder
    include WelaikaSuspenders::Actions

    def readme
      template 'README.md.erb', 'README.md'
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def raise_delivery_errors
      replace_in_file 'config/environments/development.rb',
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def provide_setup_script
      copy_file 'bin_setup', 'bin/setup'
      run 'chmod a+x bin/setup'
    end

    def enable_factory_girl_syntax
      copy_file 'factory_girl_syntax_rspec.rb', 'spec/support/factory_girl.rb'
    end

    def test_factories_first
      copy_file 'factories_spec.rb', 'spec/models/factories_spec.rb'
      append_file 'Rakefile', factories_spec_rake_task
    end

    def configure_smtp
      copy_file 'smtp.rb', 'config/initializers/smtp.rb'

      prepend_file 'config/environments/production.rb',
        "require Rails.root.join('config/initializers/smtp')\n"

      production_config = <<-RUBY
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
      RUBY

      development_config = <<-RUBY
      RUBY

      inject_into_file(
        'config/environments/production.rb',
        production_config,
        :after => 'config.action_mailer.raise_delivery_errors = false'
      )

      inject_into_file(
        'config/environments/development.rb',
        "\n\n  config.action_mailer.delivery_method = :letter_opener",
        :before => "\nend"
      )
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'

      prepend_file 'config/environments/staging.rb',
        "Mail.register_interceptor RecipientInterceptor.new(ENV['EMAIL_RECIPIENTS'])\n"
    end

    def initialize_on_precompile
      inject_into_file 'config/application.rb',
        "\n    config.assets.initialize_on_precompile = false",
        :after => 'config.assets.enabled = true'
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file '_flashes.html.slim', 'app/views/application/_flashes.html.slim'
    end

    def create_shared_javascripts
      copy_file '_javascript.html.slim', 'app/views/application/_javascript.html.slim'
    end

    def create_application_layout
      remove_file 'app/views/layouts/application.html.erb'
      template 'suspenders_layout.html.slim.erb',
        'app/views/layouts/application.html.slim',
        :force => true
    end

    def setup_javascripts
      remove_file 'app/assets/javascripts/application.js'
      copy_file 'import_common_javascripts', 'app/assets/javascripts/application.js.coffee'
    end

    def setup_presenters
      copy_file 'presenters.rb', 'config/initializers/showoff.rb'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
        :force => true
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'Gemfile_clean', 'Gemfile'
    end

    def set_ruby_to_version_being_used
      inject_into_file 'Gemfile', "\n\nruby '#{RUBY_VERSION}'",
        after: /source 'https:\/\/rubygems.org'/
    end

    def enable_database_cleaner
      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def configure_rspec
      remove_file '.rspec'
      copy_file 'rspec', '.rspec'
      prepend_file 'spec/spec_helper.rb', simplecov_init

      config = <<-RUBY
    config.generators do |generate|
      generate.test_framework :rspec
      generate.helper false
      generate.stylesheets false
      generate.javascript_engine false
      generate.view_specs false
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
      replace_in_file 'spec/spec_helper.rb', /RSpec.configure do.*end\n/m, ""

      copy_file 'rspec_config.rb', 'spec/support/rspec_config.rb'
      copy_file 'unit_spec_helper.rb', 'spec/unit_spec_helper.rb'
      copy_file 'model_spec_helper.rb', 'spec/model_spec_helper.rb'
    end

    def blacklist_active_record_attributes
      replace_in_file 'config/application.rb',
        'config.active_record.whitelist_attributes = true',
        'config.active_record.whitelist_attributes = false'
    end

    def configure_strong_parameters
      copy_file 'strong_parameters.rb', 'config/initializers/strong_parameters.rb'
    end

    def configure_time_zone
      config = <<-RUBY
    config.active_record.default_timezone = :utc

      RUBY
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_time_formats
      remove_file 'config/locales/en.yml'
      copy_file 'config_locales_en.yml', 'config/locales/en.yml'
    end

    def configure_rack_timeout
      copy_file 'rack_timeout.rb', 'config/initializers/rack_timeout.rb'
    end

    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.local"
      action_mailer_host 'test', 'www.example.com'
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def configure_capybara_webkit
      append_file 'spec/spec_helper.rb' do
        "\nCapybara.javascript_driver = :webkit"
      end
    end

    def generate_clearance
      generate 'clearance:install'
    end

    def setup_foreman
      copy_file 'sample.env', '.sample.env'
      copy_file 'sample.env', '.env'
      copy_file 'Procfile', 'Procfile'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'import_sass_styles', 'app/assets/stylesheets/application.css.sass'
    end

    def gitignore_files
      concat_file 'suspenders_gitignore', '.gitignore'
      [
        'app/assets/images',
        'app/models',
        'app/presenters',
        'app/services',
        'db/migrate',
        'log',
        'spec/controllers',
        'spec/features',
        'spec/helpers',
        'spec/lib',
        'spec/models',
        'spec/presenters',
        'spec/services',
        'spec/support',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_contexts'
        'spec/support/shared_examples',
        'spec/views',
      ].each do |dir|
        empty_directory_with_gitkeep dir
      end
    end

    def init_git
      run 'git init'
    end

    def create_heroku_apps
      path_addition = override_path_for_tests
      run "#{path_addition} heroku create #{app_name}-production --remote=production"
      run "#{path_addition} heroku create #{app_name}-staging --remote=staging"
      run "#{path_addition} heroku config:add RACK_ENV=staging RAILS_ENV=staging --remote=staging"
    end

    def create_github_repo(repo_name)
      path_addition = override_path_for_tests
      run "#{path_addition} hub create #{repo_name}"
    end

    def copy_miscellaneous_files
      copy_file 'errors.rb', 'config/initializers/errors.rb'
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset='utf-8' />
  <meta name='ROBOTS' content='NOODP' />
      EOS
      style_tags =<<-EOS
<link href='/assets/application.css' media='all' rel='stylesheet' type='text/css' />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
        replace_in_file "public/#{page}.html", /<style.+>.+<\/style>/mi, style_tags.strip
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Application\.routes\.draw do.*end/m,
        "Application.routes.draw do\nend"
    end

    def add_email_validator
      copy_file 'email_validator.rb', 'app/validators/email_validator.rb'
    end

    def disable_xml_params
      copy_file 'disable_xml_params.rb', 'config/initializers/disable_xml_params.rb'
    end

    def setup_default_rake_task
      append_file 'Rakefile' do
        "task(:default).clear\ntask :default => [:spec]"
      end
    end

    private

    def override_path_for_tests
      if ENV['TESTING']
        support_bin = File.expand_path(File.join('..', '..', '..', 'features', 'support', 'bin'))
        "PATH=#{support_bin}:$PATH"
      end
    end

    def factories_spec_rake_task
      IO.read find_in_source_paths('factories_spec_rake_task.rb')
    end

    def simplecov_init
      IO.read find_in_source_paths('simplecov_init.rb')
    end
  end
end

