class ProductItemsController < ApplicationController
  before_action :set_product_item, only: [:show, :update, :destroy]

  def index
    @product_items = ProductItem.all
    render json: @product_items
  end

  def show
    render json: @product_item
  end

  def create
    @product_item = ProductItem.new(product_item_params)
    if @product_item.save
      render json: @product_item, status: :created
    else
      render json: @product_item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product_item.update(product_item_params)
      render json: @product_item
    else
      render json: @product_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product_item.destroy
    head :no_content
  end

  private

  def set_product_item
    @product_item = ProductItem.find(params[:id])
  end

  def product_item_params
    params.require(:product_item).permit(:name, :description, :price, :quantity, :images, :product_reference_id, :archangel_id)
  end
end
