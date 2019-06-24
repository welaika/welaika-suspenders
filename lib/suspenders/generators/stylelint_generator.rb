require_relative "base"

module Suspenders
  class StylelintGenerator < Generators::Base
    def install_stylelint
      dependencies = ["stylelint",
                      "stylelint-config-recommended",
                      "stylelint-order",
                      "stylelint-declaration-block-no-ignored-properties",
                      "stylelint-scss"]
      action YarnInstall.new(self, dependencies, "--dev")
    end

    def copy_stylelint_config
      copy_file "stylelintrc.json", ".stylelintrc.json"
    end

    class YarnInstall
      def initialize(base, dependencies, flags)
        @base = base
        @dependencies = dependencies.join(" ")
        @flags = flags
      end

      def invoke!
        @base.run "bin/yarn add #{@dependencies} #{@flags}"
      end

      def revoke!
        @base.behavior = :invoke
        @base.run "bin/yarn remove #{@dependencies}"
      ensure
        @base.behavior = :revoke
      end
    end
  end
end
