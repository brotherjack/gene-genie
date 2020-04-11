RSpec.describe GeneGenie do
  it 'has a version number' do
    expect(GeneGenie::VERSION).not_to be nil
  end
end

RSpec.describe GeneGenie::Population do
  describe '#new' do
    subject { described_class.new [1, 2, 3] }

    let(:error_message) { 'Must be a hash or a GeneGenie::Chromosome' }
    it 'will raise an error if passed something other than hash or chromosome' do
      expect { subject }.to raise_error(error_message)
    end
  end
end

RSpec.describe GeneGenie::Gene do
  let(:gene_nervous_10) { described_class.new :nervous, 10 }
  let(:gene_nervous_100) { described_class.new :nervous, 100 }
  let(:gene_sleepy_10) { described_class.new :sleepy, 10 }

  describe '#===' do
    context 'when both genes have the same trait' do
      specify { expect(gene_nervous_10 === gene_nervous_100).to be_truthy }
    end

    context 'when the genes have different traits' do
      specify { expect(gene_nervous_10 === gene_sleepy_10).to be_falsey }
    end
  end

  describe '#==' do
    context 'when both genes have the sane trait and different values' do
      specify { expect(gene_nervous_10 == gene_nervous_100).to be_falsey }
    end

    context 'when the genes have different traits' do
      specify { expect(gene_nervous_10 == gene_sleepy_10).to be_falsey }
    end

    context 'when the genes have the same trait and same value' do
      specify { expect(gene_nervous_10 == described_class.new(:nervous, 10)).to be_truthy }
    end
  end
end
