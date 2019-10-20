module Suspenders
  RAILS_VERSION = "~> 6.0.0".freeze
  POSTGRES_VERSION = "11".freeze # Used in CI
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "3.0".freeze
end
