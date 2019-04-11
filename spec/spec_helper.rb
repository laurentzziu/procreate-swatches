# frozen_string_literal: true

require 'bundler/setup'
require 'procreate/swatches'

require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:suite) do
    # remove `.swatches` files created by the test suite
    dir = Dir.pwd
    all_swatches = Dir[File.join(dir, '*.swatches')]
    all_swatches.each do |file|
      if File.exist?(file) && File.basename(file).match(/\Aspec/i).present?
        File.delete(file)
      end
    end
  end
end

def path_for_file(file_name)
  File.expand_path("../support/#{file_name}", __FILE__)
end
