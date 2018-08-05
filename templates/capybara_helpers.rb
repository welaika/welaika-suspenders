module CapybaraHelpers
  def page!
    save_and_open_page
  end

  def screenshot!
    save_and_open_screenshot
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :feature
end
