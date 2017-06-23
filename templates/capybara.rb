Capybara.register_driver :chrome do |app|
  # https://stackoverflow.com/questions/26354834/netreadtimeout-netreadtimeout-selenium-ruby
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 15
  client.open_timeout = 15

  profile = Selenium::WebDriver::Chrome::Profile.new
  profile['intl.accept_languages'] = I18n.default_locale
  Capybara::Selenium::Driver.new(app, browser: :chrome, profile: profile, http_client: client)
end
Capybara.javascript_driver = :chrome
Capybara.default_driver = :chrome
Capybara.default_max_wait_time = 4

Capybara.asset_host = 'http://localhost:3000'

module CapybaraHelper
  def page!
    save_and_open_page
  end

  def screenshot!
    save_and_open_screenshot
  end
end

RSpec.configure do |config|
  config.include CapybaraHelper, type: :feature
end
