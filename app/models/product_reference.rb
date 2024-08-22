class ProductReference < ApplicationRecord
  belongs_to :product
  has_many :product_items, dependent: :destroy
end
