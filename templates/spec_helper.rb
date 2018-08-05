# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  # TODO: interactors
  add_group 'Interactions', 'app/interactions'
end

if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
  SimpleCov.coverage_dir(dir)
end

require 'webmock/rspec'
require 'timecop'

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.filter_run_when_matching :focus
  config.order = :random
  config.profile_examples = 10
  config.shared_context_metadata_behavior = :apply_to_host_groups

  Kernel.srand config.seed
end

WebMock.disable_net_connect!(allow_localhost: true)

# Only allow Timecop with block syntax
Timecop.safe_mode = true
