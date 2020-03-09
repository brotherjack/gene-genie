require_relative '../../lib/selection/roulette_wheel'
require_relative '../support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe GeneGenie::Selection::RouletteWheel do
  let(:fitness_values) { [12, 55, 20, 10, 70, 60] }
  let(:expected_values) do
    {
      4 => 1.00,
      5 => 0.6917,
      1 => 0.4274,
      2 => 0.1851,
      0 => 0.0970,
      3 => 0.0441
    }
  end 

  describe '#new' do
    context 'when passed an array' do
      subject { described_class.new fitness_values, 4 }

      specify 'wheel will have correct values in the correct order and keys' do

        expect(subject.wheel).to satisfy do |wheel|
          wheel.each do |key, value| 
            error_message = "at index #{key} expected #{value} to be "
            error_message += "within 0.01 of #{expected_values[key]} "
            error_message += "roulette wheel is #{subject.wheel}"
            expect(value).to(
              be_within(0.01).of(expected_values[key]), error_message
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

      let(:uuid_regex) { /^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$/ }

      it 'will have a wheel variable with correct values in the correct order' do

        expect(subject.wheel).to satisfy do |wheel|
          wheel.each.with_index do |(key, value), index|
            expect(value).to(
              be_within(0.01).of(expected_values.values[index]),
              "expected #{value} at #{key} to be within 0.01 of #{expected_values[index]},
 wheel is #{wheel}"
            )
            expect(key).to match(uuid_regex)
          end
        end
      end
    end
  end

  describe '#select' do
    SCORES = {
      1.00 => 4,
      0.8 => 4,
      0.6917 => 5,
      0.6 => 5,
      0.4274 => 1,
      0.2 => 1,
      0.1851 => 2,
      0.1 => 2,
      0.0970 => 0,
      0.05 => 0,
      0.0441 => 3,
      0 => 3
    }
    SCORES.each do |score, selection|
      context "when score is #{score} then #{selection} should be returned" do
        subject do
          roulette_wheel = described_class.new fitness_values, 4
          allow(roulette_wheel).to receive(:generate_random).and_return(score)
          roulette_wheel.select
        end

        it { expect(subject).to eq selection }
      end
    end
  end
end
