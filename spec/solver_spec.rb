require 'solver'

describe DistributionChallenge::Solver do
  describe '#call' do
    it 'returns password' do
      result = { :'(•̀_•́ )' => 'Targeting... almost there. Lock! I got him!',
                 :'(⌐■_■)' => 'Now, Tank now!',
                 :'--------' => '--------',
                 :'ヽ(´‿｀)ノ'  => 'Welcome to the real world, Neo.' }
      expect(described_class.call).to eq(result)
    end
  end
end