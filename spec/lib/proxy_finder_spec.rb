RSpec.describe ProxyFinder do
  let(:raw_proxies) { "104.152.45.46:80\r\n191.96.42.184:3129\r\n167.71.190.253:80\r\n" }

  before :each do
    allow(described_class).to receive(:fetch_raw_proxies).and_return(raw_proxies)

    described_class.get_more_proxies
  end

  describe 'get_proxy' do
    it 'returns a proxy' do
      expect(described_class.get_proxy).to be_present
    end
  end

  describe 'remove_proxy' do
    before do
      @proxy = described_class.random_proxy

      described_class.remove_proxy(@proxy)
    end

    it 'removes a proxy' do
      expect(described_class.proxies).not_to include(@proxy)
    end
  end

  describe 'clear' do
    before { described_class.clear }

    it 'removes all proxies' do
      expect(described_class.proxies.count).to eq(0)
    end
  end

  describe 'proxies' do
    before { described_class.get_more_proxies }

    it 'returns all proxies' do
      expect(described_class.proxies.count).to eq(3)
    end
  end
end
