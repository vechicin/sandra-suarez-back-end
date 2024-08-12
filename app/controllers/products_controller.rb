class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = Product.all
    render json: @products
  end

  def show
    if @product
      render json: @product
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find_by_composite_key(params[:product_category_id], params[:archangel_id])
  end

  def product_params
    params.require(:product).permit(:product_category_id, :archangel_id, :name, :description, :price, :quantity)
  end
end
