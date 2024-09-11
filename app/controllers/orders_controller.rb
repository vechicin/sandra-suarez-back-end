require 'httparty'
require 'base64'

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]

  def index
    @orders = Order.includes(:order_items).all
    render json: @orders.as_json(include: :order_items)
  end

  def show
    render json: @order.as_json(include: :order_items)
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    Rails.logger.info "Order update action triggered at #{Time.now}"
  
    @order.with_lock do
      if @order.update(order_params)
        if @order.status == "Processing Payment"
          token = login_to_api
          if token
            payment_result = process_payment(@order, token)
            if payment_result[:success]
              render json: @order.as_json(include: :order_items), status: :ok
            else
              render json: { error: 'Payment processing failed or payment link not received' }, status: :unprocessable_entity
            end
          else
            render json: { error: 'Failed to authenticate with payment API' }, status: :unprocessable_entity
          end
        else
          render json: @order.as_json(include: :order_items), status: :ok
        end
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::StaleObjectError
    render json: { error: 'Conflict detected while updating the order. Please try again.' }, status: :conflict
  end
  
  private

  def set_order
    @order = Order.lock('FOR UPDATE').find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'No se ha encontrado la orden' }, status: :not_found
  rescue ActiveRecord::LockWaitTimeout
    render json: { error: 'Unable to acquire lock for order. Please try again later.' }, status: :conflict
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :address, :city, :state, :email, :status, :payment_link, order_items_attributes: [:product_id, :quantity])
  end

  def login_to_api
    username = '57d99bb76cb9a1576483dc70a5b6463f'
    password = '0b36cb857fede07af4003d5e342636ae'

    encoded_credentials = Base64.strict_encode64("#{username}:#{password}").strip

    response = HTTParty.post('https://apify.epayco.co/login',
      basic_auth: {
        username: username,
        password: password
      },
      headers: {
        'Content-Type' => 'application/json; charset=UTF-8',
      },
      follow_redirects: true,
      timeout: 30
    )
    
    Rails.logger.info "Login response: #{response.body}"
    Rails.logger.info "Login status code: #{response.code}"

    if response.success?
      Rails.logger.info("Token: #{response.parsed_response['token']}")
      response.parsed_response['token']
    else
      Rails.logger.error "Login failed: #{response.body}"
      nil
    end
  end

  def process_payment(order, token)
    request_body = {
      quantity: order.order_items.sum(&:quantity),
      amount: order.order_items.sum { |item| item.quantity * item.product.price },
      currency: 'COP',
      id: 0,
      description: 'Order payment description',
      title: "Order #{order.id}",
      typeSell: 2,
      onePayment: true
    }.to_json
  
    Rails.logger.info("Body: #{request_body}")
  
    response = HTTParty.post(
      'https://apify.epayco.co/collection/link/create',
      body: request_body,
      headers: { "Content-Type" => "application/json", "Authorization" => "Bearer #{token}" }
    )
  
    if response.success?
      payment_data = response.parsed_response
      data = payment_data['data']
      route_link = data['routeLink']
  
      if route_link.present?
        ApplicationRecord.transaction do
          order.update!(payment_link: route_link)
          Rails.logger.info "Payment processed successfully: #{response.body}"
          update_product_quantities(order)
        end
        { success: true, payment_link: route_link }
      else
        Rails.logger.error "Payment link not received: #{response.body}"
        { success: false, payment_link: nil }
      end
    else
      Rails.logger.error "Payment processing failed: #{response.body}"
      { success: false, payment_link: nil }
    end
  rescue StandardError => e
    Rails.logger.error "Error in process_payment: #{e.message}"
    { success: false, payment_link: nil }
  end
  
  def update_product_quantities(order)
    ApplicationRecord.transaction do
      product_quantities = order.order_items.group_by(&:product_id).transform_values do |items|
        items.sum(&:quantity)
      end

      product_quantities.each do |product_id, total_quantity|
        product = Product.lock('FOR UPDATE').find(product_id)
        Rails.logger.info("Processing product #{product_id}: current stock #{product.quantity}, total quantity in order #{total_quantity}")
        product.reduce_stock!(total_quantity)
        Rails.logger.info("Updated product #{product_id}: new stock #{product.quantity}")
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error updating product quantities: #{e.message}"
  end
end
