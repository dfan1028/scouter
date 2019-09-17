RSpec.describe Products::Manager do
  let(:product) { Fabricate(:product) }

  let(:subject) { described_class.new(product) }

  let(:invalid_ext_id) { "#{SecureRandom.hex(8)}!@#" }

  let(:extractor_klass) { "Products::Extractor::#{product.platform.capitalize}".constantize }

  let(:fake_attributes) do
    {
      dimensions: Faker::Measurement.height,
      category: Faker::Creature::Dog.breed,
      rank: rand(1000)
    }
  end

  before :each do
    allow_any_instance_of(described_class)
      .to receive(:browser).and_return(OpenStruct.new)

    allow_any_instance_of(extractor_klass)
      .to receive(:get_attributes).and_return(fake_attributes)
  end

  describe 'create_or_update' do
    context 'error handling' do
      context 'when ext_id is invalid' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:browser).and_call_original

          product.ext_id = invalid_ext_id

          subject.create_or_update
        end

        it 'attached an error' do
          expect(subject.create_or_update.errors.any?).to be(true)
        end

        it 'unlocks resource' do
          expect($redis.get(subject.lock_key)).to eq(nil)
        end
      end

      context 'when error is not rescuable' do
        before do
          allow_any_instance_of(extractor_klass)
            .to receive(:get_attributes).and_raise(NoMethodError, 'undefined')
        end

        it 'raises error' do
          expect { subject.create_or_update }.to raise_error
        end
      end
    end

    context 'creates successfully' do
      before do
        subject.create_or_update
      end

      it 'updates attributes' do
        expect(product.reload.dimensions).to eq(fake_attributes[:dimensions])
      end

      it 'unlocks resource' do
        expect($redis.get(subject.lock_key)).to eq(nil)
      end
    end
  end

  describe 'self.lock_key' do
    it 'returns the correct key' do
      key = described_class.lock_key(product)
      expect(key).to eq("product:#{product.ext_id}:#{product.platform}")
    end
  end

end
