require 'unit_spec_helper'
require 'active_record'
require 'shoulda-matchers'

db_yml_file = File.expand_path('config/database.yml')
db_config = YAML.load_file(db_yml_file)
ActiveRecord::Base.establish_connection(db_config['test'])

# add activerecord plugins here
# require 'friendly_id'

autoload_paths = ActiveSupport::Dependencies.autoload_paths
%w(app/models app/validators).each do |path|
  autoload_paths.push(path) unless autoload_paths.include?(path)
end

