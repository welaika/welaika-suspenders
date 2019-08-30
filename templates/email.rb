# frozen_string_literal: true

if ENV['EMAIL_RECIPIENTS'].present?
  Mail.register_interceptor(
    RecipientInterceptor.new(ENV['EMAIL_RECIPIENTS'], subject_prefix: '[STAGING]')
  )
end
