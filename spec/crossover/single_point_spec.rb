# frozen_string_literal: true

require 'support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

# rubocop:disable Metrics/BlockLength
RSpec.describe GeneGenie::Crossover::SinglePoint do
  Chromosome = GeneGenie::Chromosome
  Gene = GeneGenie::Gene

  n = 6

  let(:parent_1) do
    Chromosome.new([
                     Gene.new(:strength, 18),
                     Gene.new(:dexterity, 16),
                     Gene.new(:constitution, 14),
                     Gene.new(:wisdom, 12),
                     Gene.new(:intellegence, 10),
                     Gene.new(:charisma, 8)
                   ])
  end

  let(:parent_2) do
    Chromosome.new([
                     Gene.new(:strength, 8),
                     Gene.new(:dexterity, 10),
                     Gene.new(:constitution, 12),
                     Gene.new(:wisdom, 14),
                     Gene.new(:intellegence, 16),
                     Gene.new(:charisma, 18)
                   ])
  end

  let(:one_gene_chromosome) do
    Chromosome.new([Gene.new(:x, 2)])
  end

  let(:two_gene_chromosome) do
    Chromosome.new([Gene.new(:x, 2), Gene.new(:y, 3)])
  end

  describe '#new' do
    subject(:crossover) { described_class.new parents }

    context 'when there are more than two parents' do
      let(:parents) { [parent_1, parent_2, parent_1] }
      it { expect { subject }.to raise_error ArgumentError }
    end

    context 'when there is only one parent' do
      let(:parents) { [parent_1] }
      it { expect { subject }.to raise_error ArgumentError }
    end

    context 'when a parent has only one gene' do
      let(:parents) { [parent_1, one_gene_chromosome] }
      it { expect { subject }.to raise_error IndexError }
    end

    context 'when the two chromosomes are incompatible' do
      let(:parents) { [parent_1, two_gene_chromosome] }
      it { expect { subject }.to raise_error TypeError }
    end
  end

  describe '#compatible?' do
    context 'when the lengths of the parent chromosomes do NOT match' do
      subject do
        described_class.send(:compatible?, [parent_1, one_gene_chromosome])
      end

      it { is_expected.to be_falsey }
    end

    context 'when the lengths of the parent chromosomes do match' do
      subject { described_class.send :compatible?, [parent_1, parent_2] }

      it { is_expected.to be_truthy }
    end
  end

  describe '#select_point' do
    let(:crossover) { described_class.new([parent_1, parent_2]) }

    context 'when out of points' do
      subject { crossover.send :select_point }

      it do
        crossover.instance_variable_set(:@points, [])
        expect { subject }.to raise_error IndexError
      end
    end

    (1...n).each do |point|
      context "when selected point=#{point}" do
        subject do
          crossover.instance_variable_set(:@points, points.clone)
          allow(crossover.points).to receive(:sample) { point }
          crossover.send :select_point
        end

        let(:points) { (1...n).to_a }

        it "will return #{point} and points will not contain '#{point}'" do
          is_expected.to eq point
          expect(crossover.points).to eq(points - [point])
        end
      end
    end
  end

  describe '#recombine' do
    subject { described_class.new([parent_1, parent_2]).recombine }
    let(:point) { n / 2 }
    let(:children) do
      described_class
        .new([parent_1, parent_2])
        .send(:make_children, point)
    end
    let(:probability_of_crossover) { 0.6 }

    context 'when results are less than or equal to probability of crossover' do
      let(:random_numbers) { [0.0, probability_of_crossover] }

      it 'will return both children' do
        allow_any_instance_of(described_class)
          .to receive(:rand)
          .and_return(*random_numbers)
        allow_any_instance_of(described_class)
          .to receive(:select_point)
          .and_return(point)
        is_expected.to eq [children.first, children.last]
      end
    end

    context 'when results are greater than the probability of crossover' do
      let(:random_numbers) { [probability_of_crossover + 0.01, 1.0] }
      it 'will return both parents' do
        allow_any_instance_of(described_class)
          .to receive(:rand)
          .and_return(*random_numbers)
        allow_any_instance_of(described_class)
          .to receive(:select_point)
          .and_return(point)
        is_expected.to eq [parent_1, parent_2]
      end
    end
  end

  describe '#make_children' do
    let(:crossover) { described_class.new([parent_1, parent_2]) }

    context 'when selected point is at the beginning of the array' do
      subject { crossover.send(:make_children, 0) }
      it { expect { subject }.to raise_error IndexError }
    end

    context 'when selected point is at the end of the array' do
      subject { crossover.send(:make_children, n) }
      it { expect { subject }.to raise_error IndexError }
    end

    (1..5).each do |point|
      context "...#{point}" do
        subject { crossover.send :make_children, point }

        describe 'child 1' do
          it "will have the first parent's genes up to #{point}" do
            is_expected.to satisfy do
              parent_1.genes.slice(1..point).each.with_index do |gene, index|
                gene == subject[0].genes[index]
              end
            end
          end

          it "will have the second parent's genes after #{point}" do
            is_expected.to satisfy do
              parent_2.genes.slice(point..n).each.with_index do |gene, index|
                gene == subject[0].genes[index]
              end
            end
          end
        end

        describe 'child 2' do
          it "will have the second parent's genes up to #{point}" do
            is_expected.to satisfy do
              parent_2.genes.slice(1..point).each.with_index do |gene, index|
                gene == subject[1].genes[index]
              end
            end
          end

          it "will have the first parent's genes after #{point}" do
            is_expected.to satisfy do
              parent_1.genes.slice(point..n).each.with_index do |gene, index|
                gene == subject[1].genes[index]
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
