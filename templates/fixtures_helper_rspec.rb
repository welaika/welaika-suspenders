module FixturesHelpers
  def fixture_path_for(filename)
    File.expand_path(File.join('..', '..', 'fixtures', filename), __FILE__)
  end
end

RSpec.configure do |config|
  config.include FixturesHelpers
end
