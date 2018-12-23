require 'bundler/setup'
require 'pry-byebug'
require 'awesome_print'

Bundler.require(:default, :test)

require (Pathname.new(__FILE__).dirname + '../lib/suspenders').expand_path

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include SuspendersTestHelpers

  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'

  config.default_formatter = 'doc'

  config.before(:all) do
    add_fakes_to_path
    create_tmp_directory
  end
end
