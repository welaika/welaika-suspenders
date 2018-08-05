# frozen_string_literal: true

module QueriesHelper
  def log_queries!
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  def do_not_log_queries!
    ActiveRecord::Base.logger = nil
  end

  def logging_queries
    log_queries!
    yield
  ensure
    do_not_log_queries!
  end
end

RSpec.configure do |config|
  config.include QueriesHelper
end
