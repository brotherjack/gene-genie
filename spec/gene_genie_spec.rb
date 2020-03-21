RSpec.describe GeneGenie do
  it "has a version number" do
    expect(GeneGenie::VERSION).not_to be nil
  end
end


RSpec.describe GeneGenie::Population do
  describe '#new' do
    subject { described_class.new [1,2,3] }

    let(:error_message) { "Must be a hash or a GeneGenie::Chromosome" }
    it 'will raise an error if passed something other than hash or chromosome' do
      expect{ subject }.to raise_error(error_message)
    end
  end
end
