# frozen_string_literal: true

require 'webdrivers'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.headless!
  # Set a big (15" MBP retina resolution) window size so that
  # `save_and_open_screenshot` captures the whole page.
  options.add_argument "--window-size=1680,1050"

  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    desired_capabilities: capabilities
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
