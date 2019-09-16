RSpec.describe Product, type: :model do
  subject { Fabricate(:product) }

  let(:default_platform) { 'amazon' }

  it { is_expected.to validate_presence_of(:ext_id) }

  describe 'on initialize' do
    before { @product = Product.new }

    it 'sets default platform' do
      expect(@product.platform).to eq(default_platform)
    end
  end
end
