require 'solver'

describe DistributionChallenge::Solver do
  describe '#call' do
    it 'returns password' do
      expect(described_class.call.to_s).to include('Welcome to the real world, Neo.')
    end
  end
end