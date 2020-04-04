require 'support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe GeneGenie::Crossover::SinglePoint do
  Chromosome = GeneGenie::Chromosome
  Gene = GeneGenie::Gene

  n = 6.freeze

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

  let(:max_children) { (n - 1) * 2 }
  let(:crossover) { described_class.new }

  describe '#compatible?' do
    context 'when the lengths of the parent chromosomes do NOT match' do
      subject { crossover.send :compatible?, [parent_1, one_gene_chromosome] }
      it { is_expected.to be_falsey }
    end

    context 'when the lengths of the parent chromosomes do match' do
      subject { crossover.send :compatible?, [parent_1, parent_2] }
      it { is_expected.to be_truthy }
    end
  end

  describe '#select_point' do
    subject { crossover.send :select_point }

    context 'when out of points' do
      it do
        crossover.instance_variable_set(:@points, [])
        expect{subject}.to raise_error IndexError 
      end
    end

    (1...n).each do |point|
      context "when selected point=#{point}" do
        before(:each) do
          crossover.instance_variable_set(:@points, (0..6).to_a)
        end

        it "will return #{point}" do
          allow(crossover.points).to receive(:sample) { point }
          is_expected.to eq point
        end

        it "will return points without '#{point}'" do
          allow(crossover.points).to receive(:sample) { point }
          expect(crossover.points).to eq (crossover.points - point)
        end
      end
    end
  end

  describe '#recombine' do
    context 'when there are more than two parents' do
      subject { crossover.recombine([parent_1, parent_2, parent_1]) }
      it { expect{subject}.to raise_error ArgumentError }
    end

    context 'when there is only one parent' do
      subject { crossover.recombine [parent_1] }
      it {expect{subject}.to raise_error ArgumentError }
    end

    context 'when a parent has only one gene' do
      subject { crossover.recombine [parent_1, one_gene_chromosome] }
      it { expect{subject}.to raise_error IndexError }
    end

    context 'when children is over the limit' do
      subject { crossover.recombine [parent_1, parent_2], 100_000 }
      it { expect{subject}.to raise_error RangeError }
    end

    context 'when the two chromosomes are incompatible' do
      subject { crossover.recombine [parent_1, two_gene_chromosome] }
      it { expect{subject}.to raise_error TypeError }
    end

    context 'when selected point is at...' do
      subject { crossover.recombine [parent_1, parent_2] }
      context '...the beginning of the array' do
        it do
          allow(subject).to receive(:select_point) { 0 }
          expect{subject}.to raise_error IndexError
        end
      end

      context '...the end of the array' do
        it do
          allow(subject).to receive(:select_point) { parent_1.length }
          expect{subject}.to raise_error IndexError 
        end
      end


      (1..5).each do |point|
        context "...#{point}" do
          describe 'child 1' do
            it "will have the first parent's genes up to #{point}" do
              allow(crossover).to receive(:select_point) { point }
              is_expected.to satisfy do 
                parent_1.genes.slice(1..point).each.with_index do |gene, index|
                  gene == subject[0].genes[index]
                end
              end
            end

            it "will have the second parent's genes after #{point}" do
              allow(crossover).to receive(:select_point) { point }
              is_expected.to satisfy do
                parent_2.genes.slice(point..n).each.with_index do |gene, index|
                  gene == subject[0].genes[index]
                end
              end
            end
          end

          describe 'child 2' do
            it "will have the second parent's genes up to #{point}" do
              allow(subject).to receive(:select_point) { point }
              is_expected.to satisfy do 
                parent_2.genes.slice(1..point).each.with_index do |gene, index|
                  gene == subject[1].genes[index]
                end
              end
            end

            it "will have the first parent's genes after #{point}" do
              allow(subject).to receive(:select_point) { point }
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
end
