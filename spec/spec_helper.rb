ENV["RAILS_ENV"] ||= 'test'
require './lib/riskified'

RSpec.configure do |config|
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html,

  config.backtrace_exclusion_patterns << /gems/
  config.backtrace_exclusion_patterns << /<main>/

  config.mock_with :rspec

  config.example_status_persistence_file_path = 'spec/results.txt'
end
