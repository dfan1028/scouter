RSpec.describe Locksmith do
  let(:subject) { described_class }
  let(:key) { Faker::Creature::Dog.name }

  def lock_time!
    described_class.lock(key) { "I'm a block a code!" }
  end

  describe 'lock' do
    context 'when locked once' do
      before do
        lock_time!
      end

      it 'unlocks when finished' do
        expect($redis.get(key)).to eq(nil)
      end
    end

    context 'when locked' do
      before do
        $redis.set(key, true)
      end

      it 'raises error' do
        expect { lock_time! }.to raise_error(Locksmith::Locked)
      end
    end
  end

  describe 'unlock' do
    before do
      $redis.set(key, true)
    end

    it 'unlocks' do
      expect(described_class.unlock(key)).to eq(1)
    end
  end
end
