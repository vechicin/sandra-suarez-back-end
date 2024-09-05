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
    raise "Inventario insuficiente" if quantity < order_quantity
    update!(quantity: quantity - order_quantity)
  end
end
