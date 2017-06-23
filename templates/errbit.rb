if ENV['ERRBIT_API_KEY'].present?
  Airbrake.configure do |config|
    config.host = 'http://errbit.welaika.com'
    config.project_id = 1
    config.project_key = ENV.fetch('ERRBIT_API_KEY')
    config.root_directory = Rails.root
    config.logger = Rails.logger
    config.environment = Rails.env
    config.ignore_environments = %w[test development]
    config.blacklist_keys = [/password/i]
  end
end
