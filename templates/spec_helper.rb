require 'simplecov'
SimpleCov.start 'rails' do
  # TODO: interactors
  add_group 'Services', 'app/services'
end

if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
  SimpleCov.coverage_dir(dir)

require 'webmock/rspec'
require 'timecop'

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.order = :random

  config.default_formatter = 'doc' if config.files_to_run.one?
end

WebMock.disable_net_connect!(allow_localhost: true)

# Only allow Timecop with block syntax
Timecop.safe_mode = true
