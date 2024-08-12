class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: [:show, :update, :destroy]

  def index
    @product_categories = ProductCategory.all
    render json: @product_categories
  end

  def show
    if @product_category
      render json: @product_category
    else
      render json: { error: 'Product Category not found' }, status: :not_found
    end
  end

  def create
    @product_category = ProductCategory.new(product_category_params)

    if @product_category.save
      render json: @product_category, status: :created, location: @product_category
    else
      render json: @product_category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product_category.update(product_category_params)
      render json: @product_category
    else
      render json: @product_category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product_category.destroy
    head :no_content
  end

  private

  def set_product_category
    @product_category = ProductCategory.find(params[:id])
  end

  def product_category_params
    params.require(:product_category).permit(:name)
  end
end
