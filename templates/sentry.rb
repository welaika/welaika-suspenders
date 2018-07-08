Raven.configure do |config|
  config.dsn = 'https://<key>:<secret>@sentry.io/<project>'
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
