require 'unit_spec_helper'
require 'active_record'
require 'shoulda-matchers'

db_yml_file = File.expand_path('config/database.yml')
db_config = YAML.load_file(db_yml_file)
ActiveRecord::Base.establish_connection(db_config['test'])

require File.join(RAILS_ROOT, "spec/support/database_cleaner.rb")

# add activerecord plugins here
# require 'friendly_id'

autoload_paths = ActiveSupport::Dependencies.autoload_paths
%w(app/models app/validators).each do |path|
  autoload_paths.push(path) unless autoload_paths.include?(path)
end

# find definitions only if factory girls has not been already required
if require 'factory_girl'
  require File.join(RAILS_ROOT, "spec/support/factory_girl.rb")
  FactoryGirl.find_definitions
end

