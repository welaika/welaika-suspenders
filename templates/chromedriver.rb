# frozen_string_literal: true

require 'selenium/webdriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu start-maximized] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV['SELENIUM_REMOTE_URL'].present?
      # Make the test app listen to outside requests, for the remote Selenium instance.
      Capybara.server_host = '0.0.0.0'

      # Specify the driver
      driven_by :selenium, using: :chrome, screen_size: [1400, 2000],
                           options: { url: ENV['SELENIUM_REMOTE_URL'] }

      # Get the rails application IP
      rails_ip = Socket.ip_address_list.find(&:ipv4_private?).ip_address

      # Set the rails application Port (choose what you want)
      Capybara.server_port = 3001

      # Use the IP instead of localhost so Capybara knows where to direct Selenium
      host! "http://#{rails_ip}:#{Capybara.server_port}"
    else
      # Otherwise, use the local machine's chromedriver
      driven_by :headless_chrome
    end
  end
end
