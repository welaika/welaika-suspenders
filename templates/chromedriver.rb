# frozen_string_literal: true

require 'webdrivers'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.headless!
  options.add_argument '--window-size=1680,1050'

  if ENV['CI'].present?
    # NOTE: alternative, create a chrome user
    #       https://github.com/GoogleChromeLabs/lighthousebot/blob/master/builder/Dockerfile#L35-L40
    options.add_argument '--no-sandbox'

    options.add_argument '--disable-gpu'
    options.add_argument '--disable-dev-shm-usage'
  end

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

# NOTE: here for backwards compatibility, we should use system tests
# instead now (`driven_by :headless_chrome`)
Capybara.javascript_driver = :headless_chrome

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :headless_chrome
  end
end
