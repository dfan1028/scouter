class API::ProductsController < ApplicationController

  def index
    render json: { products: Product.all }
  end

  def create
    product = manager.create_or_update

    if product.errors.blank? && product.persisted?
      render json: { success: { product: product } }
    else
      render json: {
        errors: product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if product.destroy
      render json: { success: 'Product Destroyed :(' }
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def filtered_params
    params.permit(:id, :ext_id, :use_proxy)
  end

  def product
    @product ||= Product.find(filtered_params[:id])
  end

  def manager
    @handler ||= Products::Manager.new(filtered_params)
  end

end
