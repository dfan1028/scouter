RSpec.describe Products::Browser::Amazon do
  let(:product) { Fabricate(:product) }

  let(:subject) { described_class.new(ext_id: product.ext_id) }

  let(:invalid_ext_id) { "#{SecureRandom.hex(8)}% @(" }

  let(:dummy_browser) { MissingPageBrowser.new }

  describe 'initialize' do
    context 'ext_id is valid' do
      it 'initializes' do
        expect(subject).to be_present
      end
    end

    context 'ext_id is invalid' do
      it 'raises error' do
        expect {
          described_class.new(ext_id: invalid_ext_id)
        }.to raise_error(Products::Browser::Base::InvalidExtId)
      end
    end

    context 'ext_id is blank' do
      it 'raises error' do
        expect {
          described_class.new(ext_id: '')
        }.to raise_error(Products::Browser::Base::InvalidExtId)
      end
    end
  end

  describe 'get_browser' do
    context 'when retries run out' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:new_browser).and_raise(Net::ReadTimeout)
      end

      it 'raises error' do
        expect {
          subject.get_browser(0)
        }.to raise_error(Products::Browser::Base::NoMoreRetries)
      end
    end

    context 'when page is not found' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:new_browser).and_return(dummy_browser)
      end

      it 'raises error' do
        expect {
          subject.get_browser
        }.to raise_error(Products::Browser::Base::PageNotFound)
      end
    end
  end

  describe 'product_url' do
    it 'returns correctly formatted url' do
      expect(subject.product_url).to match(/https:\/\/www.amazon.com\/dp\/.+$/)
    end
  end

  describe 'browser_settings' do
    let(:subject) { described_class.new(ext_id: product.ext_id, use_proxy: true) }

    context 'when using proxies' do
      it 'includes proxy' do
        expect(subject.send(:browser_settings)[:proxy]).to be_present
      end
    end
  end
end
