require "spec_helper"

RSpec.describe "Suspend a new project with default configuration" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_suspenders
    setup_app_dependencies
  end

  it "uses custom Gemfile" do
    gemfile_file = IO.read("#{project_path}/Gemfile")
    expect(gemfile_file).to match(
      /^ruby '#{Suspenders::RUBY_VERSION}'$/,
    )
    expect(gemfile_file).to match(
      /^gem 'active_interaction'/,
    )
    expect(gemfile_file).to match(
      /^gem 'rails', '#{Suspenders::RAILS_VERSION}'$/,
    )
  end

  it "ensures project specs pass" do
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`bundle exec rspec spec/`).to include('0 failures')
      end
    end
  end

  it "creates .ruby-version from Suspenders .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  it "copies dotfiles" do
    %w[.ctags .env.sample].each do |dotfile|
      expect(File).to exist("#{project_path}/#{dotfile}")
    end
  end

  it "doesn't generate test directory" do
    expect(File).not_to exist("#{project_path}/test")
  end

  it "loads secret_key_base from env" do
    secrets_file = IO.read("#{project_path}/config/secrets.yml")

    expect(secrets_file).
      to match(/secret_key_base: <%= ENV\["SECRET_KEY_BASE"\] %>/)
  end

  it "adds bin/setup file" do
    expect(File).to exist("#{project_path}/bin/setup")
  end

  it "makes bin/setup executable" do
    expect("bin/setup").to be_executable
  end

  it "adds support file for action mailer" do
    expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
  end

  it "configures capybara-chromedriver" do
    expect(File).to exist("#{project_path}/spec/support/chromedriver.rb")
  end

  it "adds support file for i18n" do
    expect(File).to exist("#{project_path}/spec/support/i18n.rb")
  end

  it "ensures Gemfile contains `rack-mini-profiler`" do
    gemfile = IO.read("#{project_path}/Gemfile")

    expect(gemfile).to include %{gem 'rack-mini-profiler', require: false}
  end

  it "ensures .env.sample defaults to RACK_MINI_PROFILER=0" do
    env = IO.read("#{project_path}/.env.sample")

    expect(env).to include "RACK_MINI_PROFILER=0"
  end

  it "creates a rack-mini-profiler initializer" do
    expect(File).
      to exist("#{project_path}/config/initializers/rack_mini_profiler.rb")
  end

  it "adds rspec helper for queries" do
    expect(File).to exist("#{project_path}/spec/support/queries_helper.rb")
  end

  it "configs locale and timezone" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(/^ +config.i18n.available_locales = \[:en, :it\]$/)
    expect(result).to match(/^ +config.i18n.default_locale = :it$/)

    expect(result).to match(/^ +config.time_zone = 'Rome'$/)
  end

  it "raises on unpermitted parameters in all environments" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(
      /^ +config.action_controller.action_on_unpermitted_parameters = :raise$/
    )
  end

  it "adds explicit quiet_assets configuration" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(/^ +config.assets.quiet = true$/)
  end

  it "configures public_file_server.headers in production" do
    expect(production_config).to match(
      /^ +config.public_file_server.headers = {\n +"Cache-Control" => "public,/,
    )
  end

  it "configures production environment to enforce SSL" do
    expect(production_config).to match(
      /^ +config.force_ssl = true/,
    )
  end

  it "raises on missing translations in development and test" do
    [development_config, test_config].each do |environment_file|
      expect(environment_file).to match(
        /^ +config.action_view.raise_on_missing_translations = true$/
      )
    end
  end

  it "evaluates it.yml.erb" do
    locales_it_file = IO.read("#{project_path}/config/locales/it.yml")
    expect(locales_it_file).to match(/application: #{app_name.humanize}/)
  end

  it "configs :letter_opener as email delivery method for development" do
    dev_env_file = IO.read("#{project_path}/config/environments/development.rb")
    expect(dev_env_file).
      to match(/^ +config.action_mailer.delivery_method = :letter_opener$/)
  end

  it "configs simplecov" do
    spec_helper_file = IO.read("#{project_path}/spec/spec_helper.rb")
    expect(spec_helper_file).to match(/^require 'simplecov'$/)
    expect(spec_helper_file).to match(/^SimpleCov.start 'rails' do$/)
  end

  it "sets action mailer default host and asset host" do
    config_key = 'config\.action_mailer\.asset_host'
    config_value =
      %q{ENV\.fetch\("ASSET_HOST", ENV\.fetch\("APPLICATION_HOST"\)\)}
    expect(production_config).to match(/#{config_key} = #{config_value}/)
  end

  it "uses APPLICATION_HOST, not HOST in the production config" do
    expect(production_config).to match(/"APPLICATION_HOST"/)
    expect(production_config).not_to match(/"HOST"/)
  end

  it "configures email interceptor" do
    email_file = File.join(project_path, "config", "initializers", "email.rb")
    email_config = IO.read(email_file)

    expect(email_config).
      to include(%{RecipientInterceptor.new(ENV["EMAIL_RECIPIENTS"], subject_prefix: '[STAGING]'})
  end

  it "configs bullet gem in development" do
    expect(development_config).to match /^ +Bullet.enable = true$/
    expect(development_config).to match /^ +Bullet.bullet_logger = true$/
    expect(development_config).to match /^ +Bullet.rails_logger = true$/
  end

  it "configs missing assets to raise in test" do
    expect(test_config).to match(
      /^ +config.assets.raise_runtime_errors = true$/,
    )
  end

  it "adds rspec's helper files" do
    expect(File).to exist("#{project_path}/spec/spec_helper.rb")
    expect(File).to exist("#{project_path}/spec/rails_helper.rb")
  end

  it "adds rubocop configuration file" do
    expect(File).to exist("#{project_path}/.rubocop.yml")
  end

  it "creates binstubs" do
    expect(File).to exist("#{project_path}/bin/brakeman")
    expect(File).to exist("#{project_path}/bin/rubocop")
    expect(File).to exist("#{project_path}/bin/rspec")
    expect(File).to exist("#{project_path}/bin/overcommit")
  end

  it "removes comments and extra newlines from config files" do
    config_files = [
      IO.read("#{project_path}/config/application.rb"),
      IO.read("#{project_path}/config/environment.rb"),
      development_config,
      test_config,
      production_config,
    ]

    config_files.each do |file|
      expect(file).not_to match(%r{.*#.*})
      expect(file).not_to eq(file.strip)
      expect(file).not_to match(%r{^$\n\n})
    end
  end

  it "creates review apps setup script" do
    bin_setup_path = "#{project_path}/bin/setup_review_app"
    bin_setup = IO.read(bin_setup_path)

    expect(bin_setup).to include("PARENT_APP_NAME=#{app_name.dasherize}-staging")
    expect(bin_setup).to include("APP_NAME=#{app_name.dasherize}-staging-pr-$1")
    expect(bin_setup).
      to include("heroku run rails db:migrate --exit-code --app $APP_NAME")
    expect(bin_setup).to include("heroku ps:scale worker=1 --app $APP_NAME")
    expect(bin_setup).to include("heroku restart --app $APP_NAME")

    expect("bin/setup_review_app").to be_executable
  end

  it "creates deploy script" do
    bin_deploy_path = "#{project_path}/bin/deploy"
    bin_deploy = IO.read(bin_deploy_path)

    expect(bin_deploy).to include("heroku run rails db:migrate --exit-code")
    expect("bin/deploy").to be_executable
  end

  it "creates heroku application manifest file with application name in it" do
    app_json_file = IO.read("#{project_path}/app.json")

    expect(app_json_file).to match(/"name":\s*"#{app_name.dasherize}"/)
  end

  def app_name
    SuspendersTestHelpers::APP_NAME
  end

  it "adds high_voltage" do
    gemfile = IO.read("#{project_path}/Gemfile")
    expect(gemfile).to match(/high_voltage/)
  end

  it "adds sassc-rails" do
    gemfile = read_project_file("Gemfile")

    expect(gemfile).to match(/sassc-rails/)
  end

  it "doesn't use turbolinks" do
    app_js = read_project_file(%w(app assets javascripts application.js))
    expect(app_js).not_to match(/turbolinks/)
  end

  it "configures Timecop safe mode" do
    spec_helper = read_project_file(%w(spec spec_helper.rb))
    expect(spec_helper).to match(/Timecop.safe_mode = true/)
  end

  def development_config
    @_development_config ||=
      read_project_file %w(config environments development.rb)
  end

  def test_config
    @_test_config ||= read_project_file %w(config environments test.rb)
  end

  def production_config
    @_production_config ||=
      read_project_file %w(config environments production.rb)
  end

  def read_project_file(path)
    IO.read(File.join(project_path, *path))
  end
end
