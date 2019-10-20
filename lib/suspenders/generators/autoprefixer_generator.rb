require_relative "base"

module Suspenders
  class AutoprefixerGenerator < Generators::Base
    def add_autoprefixer_rails
      gem 'autoprefixer-rails'
      Bundler.with_clean_env { run "bundle install" }
    end

    def copy_browserslistrc
      if behavior == :invoke
        list = <<~TEXT
          last 1 version
          > 5%
          not IE 11
        TEXT
        in_root do
          File.open('.browserslistrc', 'w') do |file|
            file << list
          end
        end
      else
        in_root do
          File.open('.browserslistrc', 'w') do |file|
            file << 'defaults'
          end
        end
      end
    end
  end
end
