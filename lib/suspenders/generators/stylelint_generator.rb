require_relative "base"

module Suspenders
  class StylelintGenerator < Generators::Base
    def install_stylelint
      dependencies = [
        { name: "stylelint", version: '10' }, # FIXME: config-recommened is not ready for stylelint 11 yet
        { name: "stylelint-config-recommended" },
        { name: "stylelint-order" },
        { name: "stylelint-declaration-block-no-ignored-properties" },
        { name: "stylelint-scss" }
      ]
      action YarnInstall.new(self, dependencies, "--dev")
    end

    def copy_stylelint_config
      copy_file "stylelintrc.json", ".stylelintrc.json"
    end

    class YarnInstall
      def initialize(base, dependencies, flags)
        @base = base
        @dependencies = dependencies
        @flags = flags
      end

      def invoke!
        dependencies_with_versions = @dependencies.map { |d| d[:version] ? "#{d[:name]}@#{d[:version]}" : d[:name] }.join(' ')
        @base.run "bin/yarn add #{dependencies_with_versions} #{@flags}"
      end

      def revoke!
        @base.behavior = :invoke
        @base.run "bin/yarn remove #{@dependencies.map { |d| d[:name] }.join(' ')}"
      ensure
        @base.behavior = :revoke
      end
    end
  end
end
