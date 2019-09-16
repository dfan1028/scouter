RSpec.describe Product, type: :model do
  subject { Product.new }

  it { is_expected.to validate_presence_of(:ext_id) }
end
