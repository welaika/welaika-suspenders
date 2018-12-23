require "spec_helper"

RSpec.describe "Heroku" do
  context "--heroku" do
    before(:all) do
      clean_up
      run_suspenders("--heroku=true")
      setup_app_dependencies
    end
    let(:app_name) { SuspendersTestHelpers::APP_NAME.dasherize }

    it "suspends a project for Heroku" do
      expect(FakeHeroku).to have_created_app_for("staging", "--region eu")
      expect(FakeHeroku).to have_created_app_for("production", "--region eu")
      %w(staging production).each do |env|
        expect(FakeHeroku).to have_configured_vars(env, "APPLICATION_HOST")
        expect(FakeHeroku).to have_configured_vars(env, "SENTRY_DSN")
        expect(FakeHeroku).to have_configured_vars(env, "SENTRY_ENV")
        expect(FakeHeroku).to have_configured_vars(env, "SMTP_ADDRESS")
        expect(FakeHeroku).to have_configured_vars(env, "SMTP_DOMAIN")
        expect(FakeHeroku).to have_configured_vars(env, "SMTP_PASSWORD")
        expect(FakeHeroku).to have_configured_vars(env, "SMTP_USERNAME")
      end
      expect(FakeHeroku).to have_setup_pipeline_for(app_name)

      bin_setup_path = "#{project_path}/bin/setup"
      bin_setup = IO.read(bin_setup_path)

      expect(bin_setup).to match(/^if heroku join --app #{app_name}-production/)
      expect(bin_setup).to match(/^if heroku join --app #{app_name}-staging/)
      expect(bin_setup).to match(/^git config heroku.remote staging/)
      expect(File.stat(bin_setup_path)).to be_executable

      readme = IO.read("#{project_path}/README.md")

      expect(readme).to include("./bin/deploy staging")
      expect(readme).to include("./bin/deploy production")
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

      expect(File.stat(bin_setup_path)).to be_executable
    end

    it "creates deploy script" do
      bin_deploy_path = "#{project_path}/bin/deploy"
      bin_deploy = IO.read(bin_deploy_path)

      expect(bin_deploy).to include("heroku run rails db:migrate --exit-code")
      expect(File.stat(bin_deploy_path)).to be_executable
    end

    it "creates heroku application manifest file with application name in it" do
      app_json_file = IO.read("#{project_path}/app.json")

      expect(app_json_file).to match(/"name":\s*"#{app_name.dasherize}"/)
    end
  end

  def clean_up
    drop_dummy_database
    remove_project_directory
    FakeHeroku.clear!
  end
end
