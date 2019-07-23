module Suspenders
  RAILS_VERSION = "~> 5.2.3".freeze
  POSTGRES_VERSION = "10.6".freeze # Used in CI
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "2.33".freeze
end
