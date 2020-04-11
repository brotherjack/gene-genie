# frozen_string_literal: true

$LOAD_PATH << 'lib'
$LOAD_PATH << 'lib/selection'
$LOAD_PATH << 'lib/crossover'

require 'bundler/setup'
require 'gene_genie'
require 'roulette_wheel'
require 'single_point'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
