RSpec.describe Products::Extractor::Amazon do
  let(:subject) { described_class.new(OpenStruct.new) }

  describe 'get_attributes' do
    context 'when no selectors match' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:details).and_return(nil)
      end

      it 'returns empty hash' do
        expect(subject.get_attributes).to eq({})
      end
    end

    context 'when selector matches' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:details).and_return(ProductDetails.valid)
      end

      context 'when content matches' do
        it 'finds attributes' do
          expect(subject.get_attributes.keys.count).to eq(3)
        end
      end

      context 'when content does not match' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:details).and_return(Faker::Movies::HarryPotter.quote)
        end

        it 'return empty hash' do
          expect(subject.get_attributes).to eq({})
        end
      end
    end
  end
end
