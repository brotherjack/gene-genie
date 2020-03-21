require 'support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe GeneGenie::Crossover::SinglePoint do
  before(:each) do
    GeneGenie::Population
  end
end
