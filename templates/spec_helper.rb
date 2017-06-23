require 'simplecov'
require 'simplecov-json'
SimpleCov.start 'rails' do
  add_group 'Services', 'app/services'
end
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

require 'webmock/rspec'

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
