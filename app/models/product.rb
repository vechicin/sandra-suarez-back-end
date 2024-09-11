class Product < ApplicationRecord
  belongs_to :product_reference
  belongs_to :archangel

  has_many :order_items
  has_many :orders, through: :order_items

  validates :product_reference, :archangel, :quantity, :price, :images, presence: true

  def product_reference_info
    product_reference.as_json(only: [:name, :description])
  end

  def archangel_info
    archangel.as_json(only: [:name, :description, :color])
  end

  def reduce_stock!(order_quantity)
    ApplicationRecord.transaction do
      Rails.logger.info("Attempting to reduce stock for product #{id}: current quantity #{quantity}, reduce by #{order_quantity}")
      if quantity >= order_quantity
        new_quantity = quantity - order_quantity
        Rails.logger.info("Reducing stock for product #{id}: new quantity #{new_quantity}")
        update!(quantity: new_quantity)
      else
        raise "Insufficient inventory for product #{id}"
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error reducing stock for product #{id}: #{e.message}"
    raise
  end  
end
