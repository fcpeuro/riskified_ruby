ENV["RAILS_ENV"] ||= 'test'

require './lib/riskified'
require 'factory_bot'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.backtrace_exclusion_patterns << /gems/
  config.backtrace_exclusion_patterns << /<main>/
  config.mock_with :rspec
  config.example_status_persistence_file_path = 'spec/results.txt'
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
