class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items

  validates :order_items, presence: true

  before_save :update_quantity

  private

  def update_quantity
    order_items.each do |order_item|
      product = order_item.product
      product.reduce_stock!(order_item.quantity)
    end
  end
end
