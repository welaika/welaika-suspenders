require 'active_support/dependencies'
require 'showcase'

# add project root to load path
RAILS_ROOT = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift(RAILS_ROOT) unless $LOAD_PATH.include?(RAILS_ROOT)

require File.join(RAILS_ROOT, "spec/support/rspec_config.rb")

# push project directories to load
autoload_paths = ActiveSupport::Dependencies.autoload_paths
%w(app/presenters).each do |path|
  autoload_paths.push(path) unless autoload_paths.include?(path)
end
