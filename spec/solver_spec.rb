require 'solver'

describe DistributionChallenge::Solver do
  describe '#call' do
    it 'returns password' do
      expect(described_class.call).to eq(true)
    end
  end
end