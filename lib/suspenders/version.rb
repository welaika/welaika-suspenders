module Suspenders
  RAILS_VERSION = "~> 5.1.2".freeze
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "2.27.0".freeze
end
