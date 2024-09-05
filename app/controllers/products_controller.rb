class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = Product.all
    render json: @products.as_json(
      include: {
        product_reference: { only: [:name, :description] },
        archangel: { only: [:name, :description, :color] }
      }
    )
  end

  def show
    render json: @product.as_json(
      include: {
        product_reference: { only: [:name, :description] },
        archangel: { only: [:name, :description, :color] }
      }
    )
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
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
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :quantity, :images, :product_reference_id, :archangel_id)
  end
end
