require 'support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe GeneGenie::Crossover::SinglePoint do
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

  let(:incompatible_length) do
    Chromosome.new(Gene.new(:x, 2))
  end

  let(:crossover) { described_class.new }

  describe '#compatible?' do
    subject { crossover.send :compatible? }
    context 'when the lengths of the parent chromosomes do NOT match' do
      it { is_expected.to be_falsey }
    end

    context 'when the lengths of the parent chromosomes do match' do
      it { is_expected.to be_truthy }
    end
  end
end
