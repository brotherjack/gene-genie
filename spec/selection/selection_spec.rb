require '../lib/genetic'
require '../lib/selection/selection'
require 'securerandom'
require './support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe GeneGenie::Selection::Method do
  describe '#normalize' do
    let(:array_of_floats) { [2597.9, 8.2, 1.2, 714.37, 47.9, 1.1] }
    let(:normalized_array_of_floats) {  [0.01, 0.1, 0.42, 0.45, 0.0, 0.02] }  
    let(:normalized_array) { [0.77, 0.0, 0.0, 0.21, 0.01, 0.0] }

    context 'when passed an array of numbers' do
      let(:array_of_integers) { [123, 2_313, 9_704, 10_293, 3, 452] }

      context 'when integers' do
        subject { described_class.new.normalize array_of_integers }

        it 'will return a hash with the index keyed to the normalized values' do
          expect(subject.values).to eq normalized_array_of_floats
          expect(subject.keys).to eq (0..normalized_array_of_floats.length-1).to_a
        end

        context 'when a rounding number is given' do
          subject { described_class.new.normalize array_of_integers, round_to }

          let(:round_to) { 4 }
          let(:normalized) { [0.0054, 0.1011, 0.424, 0.4497, 0.0001, 0.0197] }

          it 'will return a hash with the index keyed to the normalized values' do
            expect(subject.values).to eq normalized
            expect(subject.keys).to eq (0..normalized.length-1).to_a
          end
        end
      end

      context 'when floats' do
        subject { described_class.new.normalize array_of_floats }

        it 'will return a hash with the index keyed to the normalized values' do
          expect(subject.values).to eq normalized_array
          expect(subject.keys).to eq (0..normalized_array.length-1).to_a
        end

        context 'when a rounding number is given' do
          subject { described_class.new.normalize array_of_floats, round_to }
          let(:round_to) { 4 }
          let(:normalized) { [0.7707, 0.0024, 0.0004, 0.2119, 0.0142, 0.0003] }

          it 'will return a hash with the index keyed to the normalized values' do
            expect(subject.values).to eq normalized
            expect(subject.keys).to eq (0..normalized.length-1).to_a
          end
        end
      end
    end

    context 'when passed a population' do
      context 'when the population already has fitness scores' do
        subject do
          selector = described_class.new
          selector.normalize population
          population.fitness_scores.values
        end

        let(:population) { create_population_with_fitness_scores array_of_floats }

        it { expect(subject).to eq normalized_array }
      end

      context 'when population does not have fitness scores' do
        subject { described_class.new.normalize population }

        let(:trait) { :body_size }
        let(:population) do
          chromosomes = array_of_floats.each.inject([]) do |acc, f|
            acc << GeneGenie::Chromosome.new([GeneGenie::Gene.new(trait, f)])
            acc
          end
          GeneGenie::Population.new chromosomes
        end
        let(:error_message) { 'Population does not have fitness scores' }

        it { expect{subject}.to raise_error(error_message) }
      end
    end
  end
end
