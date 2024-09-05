class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  def index
    @orders = Order.includes(:order_items).all
    render json: @orders, include: :order_items
  end

  def show
    render json: @order, include: :order_items
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'No se ha encontrado la orden' }, status: :not_found
  end

  def order_params
    params.require(:order).permit(order_items_attributes: [:product_id, :quantity])
  end
end
