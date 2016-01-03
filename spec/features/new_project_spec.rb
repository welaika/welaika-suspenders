require "spec_helper"

RSpec.describe "Suspend a new project with default configuration" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_suspenders
  end

  it "ensures project specs pass" do
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end

  it "inherits staging config from production" do
    staging_file = IO.read("#{project_path}/config/environments/staging.rb")
    config_stub = "Rails.application.configure do"

    expect(staging_file).to match(/^require_relative "production"/)
    expect(staging_file).to match(/#{config_stub}/), staging_file
  end

  it "creates .ruby-version from Suspenders .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  it 'creates .ruby-gemset from app name' do
    ruby_gemset_file = IO.read("#{project_path}/.ruby-gemset")

    expect(ruby_gemset_file).to eq("#{app_name}\n")
  end

  it "copies dotfiles" do
    %w[.ctags .env].each do |dotfile|
      expect(File).to exist("#{project_path}/#{dotfile}")
    end
  end

  it "loads secret_key_base from env" do
    secrets_file = IO.read("#{project_path}/config/secrets.yml")

    expect(secrets_file).to match(/secret_key_base: <%= ENV\["SECRET_KEY_BASE"\] %>/)
  end

  it "adds bin/setup file" do
    expect(File).to exist("#{project_path}/bin/setup")
  end

  it "makes bin/setup executable" do
    bin_setup_path = "#{project_path}/bin/setup"

    expect(File.stat(bin_setup_path)).to be_executable
  end

  it "adds support file for action mailer" do
    expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
  end

  it "configures capybara-webkit" do
    expect(File).to exist("#{project_path}/spec/support/capybara_webkit.rb")
  end

  it "adds support file for i18n" do
    expect(File).to exist("#{project_path}/spec/support/i18n.rb")
  end

  it "adds support file for factory girl" do
    expect(File).to exist("#{project_path}/spec/support/factory_girl.rb")
  end

  it "adds rspec helper for fixtures" do
    expect(File).to exist("#{project_path}/spec/support/fixtures_helper.rb")
  end

  it "adds rspec helper for queries" do
    expect(File).to exist("#{project_path}/spec/support/queries_helper.rb")
  end

  it "configs locale and timezone" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(/^ +config.i18n.enforce_available_locales = true$/)
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

    expect(result).to match(
      /^ +config.quiet_assets = true$/
    )
  end

  it "raises on missing translations in development and test" do
    %w[development test].each do |environment|
      environment_file =
        IO.read("#{project_path}/config/environments/#{environment}.rb")
      expect(environment_file).to match(
        /^ +config.action_view.raise_on_missing_translations = true$/
      )
    end
  end

  it "evaluates it.yml.erb" do
    locales_it_file = IO.read("#{project_path}/config/locales/it.yml")
    expect(locales_it_file).to match(/application: #{app_name.humanize}/)
  end

  it "configs simple_form" do
    expect(File).to exist("#{project_path}/config/initializers/simple_form.rb")
  end

  it "configs :letter_opener as email delivery method for development" do
    dev_env_file = IO.read("#{project_path}/config/environments/development.rb")
    expect(dev_env_file).
      to match(/^ +config.action_mailer.delivery_method = :letter_opener$/)
  end

  it "configs simplecov" do
    spec_helper_file = IO.read("#{project_path}/spec/spec_helper.rb")
    expect(spec_helper_file).to match(/^require "simplecov"$/)
    expect(spec_helper_file).to match(/^SimpleCov.start "rails" do$/)
  end

  it "uses APPLICATION_HOST, not HOST in the production config" do
    prod_env_file = IO.read("#{project_path}/config/environments/production.rb")
    expect(prod_env_file).to match(/"APPLICATION_HOST"/)
    expect(prod_env_file).not_to match(/"HOST"/)
  end

  it "configures language in html element" do
    layout_path = "/app/views/layouts/application.html.slim"
    layout_file = IO.read("#{project_path}#{layout_path}")
    expect(layout_file).to match(/html lang="it"/)
  end

  it "configs active job queue adapter" do
    application_config = IO.read("#{project_path}/config/application.rb")
    test_config = IO.read("#{project_path}/config/environments/test.rb")

    expect(application_config).to match(
      /^ +config.active_job.queue_adapter = :delayed_job$/
    )
    expect(test_config).to match(
      /^ +config.active_job.queue_adapter = :inline$/
    )
  end

  it "configs bullet gem in development" do
    test_config = IO.read("#{project_path}/config/environments/development.rb")

    expect(test_config).to match /^ +Bullet.enable = true$/
    expect(test_config).to match /^ +Bullet.bullet_logger = true$/
    expect(test_config).to match /^ +Bullet.rails_logger = true$/
  end

  it "configs missing assets to raise in test" do
    test_config = IO.read("#{project_path}/config/environments/test.rb")

    expect(test_config).to match(
      /^ +config.assets.raise_runtime_errors = true$/,
    )
  end

  it "adds spring to binstubs" do
    expect(File).to exist("#{project_path}/bin/spring")

    bin_stubs = %w(rake rails rspec)
    bin_stubs.each do |bin_stub|
      expect(IO.read("#{project_path}/bin/#{bin_stub}")).to match(/spring/)
    end
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
  end

  it "removes comments and extra newlines from config files" do
    config_files = [
      IO.read("#{project_path}/config/application.rb"),
      IO.read("#{project_path}/config/environment.rb"),
      IO.read("#{project_path}/config/environments/development.rb"),
      IO.read("#{project_path}/config/environments/production.rb"),
      IO.read("#{project_path}/config/environments/test.rb"),
    ]

    config_files.each do |file|
      expect(file).not_to match(/.*#.*/)
      expect(file).not_to match(/^$\n/)
    end
  end

  def app_name
    SuspendersTestHelpers::APP_NAME
  end
end
