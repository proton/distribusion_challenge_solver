require 'password_loader'

describe DistributionChallenge::PasswordLoader do
  describe '#call' do
    it 'returns password' do
      expect(described_class.call).to eq('Kans4s-i$-g01ng-by3-bye')
    end
  end
end