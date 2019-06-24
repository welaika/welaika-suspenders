require "suspenders/version"
require "suspenders/generators/app_generator"
require "suspenders/generators/static_generator"
require "suspenders/generators/stylesheet_base_generator"
require "suspenders/generators/stylelint_generator"
require "suspenders/generators/ci_generator"
require "suspenders/generators/db_optimizations_generator"
require "suspenders/generators/factories_generator"
require "suspenders/generators/lint_generator"
require "suspenders/generators/views_generator"
require "suspenders/generators/js_driver_generator"
require "suspenders/generators/json_generator"
require "suspenders/generators/testing_generator"
require "suspenders/generators/decorator_generator"
require "suspenders/generators/faker_generator"
require "suspenders/generators/security_generator"
require "suspenders/generators/import_dump_generator"
require "suspenders/generators/production/force_tls_generator"
require "suspenders/generators/production/email_generator"
require "suspenders/generators/production/timeout_generator"
require "suspenders/generators/production/error_reporting_generator"
require "suspenders/generators/production/deployment_generator"
require "suspenders/generators/production/manifest_generator"
require "suspenders/generators/staging/pull_requests_generator"
require "suspenders/actions"
require "suspenders/adapters/heroku"
require "suspenders/app_builder"
