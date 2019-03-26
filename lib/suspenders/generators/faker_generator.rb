require_relative "base"

module Suspenders
  class FakerGenerator < Generators::Base
    def add_factory_bot
      gem 'faker', group: %i(development test)
      Bundler.with_clean_env { run "bundle install" }
    end

    def set_up_faker
      copy_file 'faker_rspec.rb', 'spec/support/faker.rb'
    end
  end
end
