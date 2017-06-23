if Rails.env.development? || Rails.env.test?
  require 'slim_lint/rake_task'
  SlimLint::RakeTask.new do |t|
    t.files = ['app/views']
  end
end
