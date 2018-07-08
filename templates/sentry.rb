Raven.configure do |config|
  config.dsn = ENV.fetch('SENTRY_DSN')
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments = %w[ staging production ]
  config.current_environment = ENV.fetch('SENTRY_CURRENT_ENV')
end
