ENV['RACK_ENV'] ||= 'test'
require 'require_all'

require File.expand_path('../config/application.rb', __dir__)

require ProgImageStorage.root.join 'spec/spec_helper_methods.rb'
require_all Dir.glob('spec/support/shared_context/*.rb')
require_all Dir.glob('spec/support/shared_examples/*.rb')

require 'rspec/its'
require 'rack/test'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed
end
