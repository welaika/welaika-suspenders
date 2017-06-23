Capybara.javascript_driver = :webkit
Capybara.asset_host = 'http://localhost:3000'

module CapybaraHelper
  def page!
    save_and_open_page
  end

  def screenshot!
    save_and_open_screenshot
  end
end

Capybara::Webkit.configure do |config|
  config.allow_url(%w[fonts.googleapis.com])
end

RSpec.configure do |config|
  config.include CapybaraHelper, type: :feature
end
