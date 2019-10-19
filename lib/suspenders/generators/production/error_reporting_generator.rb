require "rails/generators"
require_relative "../../actions"

module Suspenders
  module Production
    class ErrorReportingGenerator < Generators::Base
      def add_sentry
        gem "sentry-raven"
        Bundler.with_clean_env { run "bundle install" }
      end

      def set_up_sentry
        copy_file "sentry.rb", "config/initializers/sentry.rb"
      end

      def configure_sentry_context
        inject_into_class(
          "app/controllers/application_controller.rb",
          'ApplicationController',
          context_configuration
        )
      end

      def env_vars
        expand_json(
          "app.json",
          env: {
            SENTRY_DSN: { required: true },
            SENTRY_ENV: { required: true }
          }
        )
      end

      private

      def context_configuration
        <<-RUBY
  before_action :set_raven_context

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
        RUBY
      end
    end
  end
end
