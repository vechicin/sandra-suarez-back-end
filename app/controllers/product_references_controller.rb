class ProductReferencesController < ApplicationController
  before_action :set_product_reference, only: [:show, :update, :destroy]

  def index
    @product_references = ProductReference.all
    render json: @product_references
  end

  def show
    render json: @product_reference, include: :products
  end

  def products
    @products = @product_reference.products
    render json: @products
  end

  def create
    @product_reference = ProductReference.new(product_reference_params)
    if @product_reference.save
      render json: @product_reference, status: :created
    else
      render json: @product_reference.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product_reference.update(product_reference_params)
      render json: @product_reference
    else
      render json: @product_reference.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product_reference.destroy
    head :no_content
  end

  private

  def set_product_reference
    @product_reference = ProductReference.find(params[:id])
  end

  def product_reference_params
    params.require(:product_reference).permit(:name, :description, :product_category_id)
  end
end
