RSpec.describe Products::Errors::Handler do
  let(:product) { Fabricate(:product) }

  let(:subject) { described_class.new(product) }

  let(:lock_key) { Products::Manager.lock_key(product) }

  let(:rescuable_error) { Products::Browser::Base::PageNotFound.new("Page Not Found") }

  let(:non_rescuable_error) { Net::ReadTimeout.new("Timed out :(") }

  describe 'process' do
    before :each do
      $redis.set(lock_key, true)
    end

    context 'when error is rescuable' do
      it 'does not raise error' do
        expect { subject.process(rescuable_error) }.not_to raise_error
      end

      it 'attaches error message' do
        expect(subject.process(rescuable_error).errors.any?).to be(true)
      end

      it 'unlocks' do
        subject.process(rescuable_error)
        expect($redis.get(lock_key)).to eq(nil)
      end
    end

    context 'when error is not rescuable' do
      it 'raises error and unlocks' do
        expect { subject.process(non_rescuable_error) }.to raise_error(Net::ReadTimeout)
        expect($redis.get(lock_key)).to eq(nil)
      end
    end
  end

end
