class Product < ApplicationRecord
  belongs_to :product_reference
  belongs_to :archangel

  validates :product_reference, :archangel, :quantity, :price, :images, presence: true

  def product_reference_info
    product_reference.as_json(only: [:name, :description])
  end

  def archangel_info
    archangel.as_json(only: [:name, :description, :color])
  end
end
