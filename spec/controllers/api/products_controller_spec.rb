RSpec.describe API::ProductsController, type: :controller do
  let(:product) { Fabricate(:product) }

  describe 'index' do
    before :each do
      2.times { Fabricate(:product) }

      get :index
    end

    it 'returns all products' do
      expect(JSON.parse(response.body)['products'].count).to eq(2)
    end

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe 'create' do
    let(:invalid_ext_id) { '$#fs83j ^43' }
    let(:valid_ext_id) { SecureRandom.hex(8) }

    context 'with valid ext_id' do
      before :each do
        allow_any_instance_of(Products::Manager).to receive(:create_or_update).and_return(product)

        post :create, params: { ext_id: valid_ext_id }
      end

      it 'returns the product created' do
        response_product = JSON.parse(response.body).dig('success', 'product')
        expect(response_product).to be_present
      end

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'with invalid ext_id' do
      before :each do
        post :create, params: { ext_id: invalid_ext_id }
      end

      it 'returns an error message' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'destroy' do
    before :each do
      delete :destroy, params: { id: product.id }
    end

    it 'is successful' do
      expect(response).to be_successful
    end
  end
end
