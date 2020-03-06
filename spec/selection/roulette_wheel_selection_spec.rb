require_relative '../../lib/selection/roulette_wheel'

RSpec.describe Genetic::Selection::RouletteWheel do
  describe '#new' do
    subject { described_class.new fitness_values }

    let(:fitness_values) { [12, 55, 20, 10, 70, 60] }
    let(:expected_values) { [1.00, 0.6917, 0.4274, 0.1851, 0.0970, 0.0441] }

    it 'will have a wheel variable with correct values in the correct order' do

      expect(subject.wheel).to satisfy do |wheel|
        wheel.each.with_index do |value, index|
          error_message = "at index #{index} expected #{value} to be "
          error_message += "within 0.01 of #{expected_values[index]} "
          error_message += "roulette wheel is #{subject.wheel}"
          expect(value).to(be_within(0.01).of(expected_values[index]), error_message)
        end
      end
    end
  end
end
