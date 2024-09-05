class ProductCategory < ApplicationRecord
  has_many :product_references, dependent: :destroy
end
