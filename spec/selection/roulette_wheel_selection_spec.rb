require_relative '../../lib/selection/roulette_wheel'
require_relative '../support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe Genetic::Selection::RouletteWheel do
  let(:fitness_values) { [12, 55, 20, 10, 70, 60] }
  let(:expected_values) { [1.00, 0.6917, 0.4274, 0.1851, 0.0970, 0.0441] }

  describe '#new' do
    context 'when passed an array' do
      subject { described_class.new fitness_values, 4 }

      it 'will have a wheel variable with correct values in the correct order' do

        expect(subject.wheel).to satisfy do |wheel|
          wheel.each.with_index do |value, index|
            error_message = "at index #{index} expected #{value} to be "
            error_message += "within 0.01 of #{expected_values[index]} "
            error_message += "roulette wheel is #{subject.wheel}"
            expect(value).to(
              be_within(0.01).of(expected_values[index]), error_message
            )
          end
        end
      end
    end

    context 'when passed a population' do
      subject do
        population = create_population_with_fitness_scores fitness_values
        described_class.new population, 4
      end

      it 'will have a wheel variable with correct values in the correct order' do

        expect(subject.wheel).to satisfy do |wheel|
          wheel.each.with_index do |value, index|
            error_message = "at index #{index} expected #{value} to be "
            error_message += "within 0.01 of #{expected_values[index]} "
            error_message += "roulette wheel is #{subject.wheel}"
            expect(value).to(
              be_within(0.01).of(expected_values[index]), error_message
            )
          end
        end
      end
    end
  end
end
