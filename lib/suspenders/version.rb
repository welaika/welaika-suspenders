module Suspenders
  RAILS_VERSION = "~> 5.2.2".freeze
  POSTGRES_VERSION = "10.4".freeze # Used in CI
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "2.30.0".freeze
end
