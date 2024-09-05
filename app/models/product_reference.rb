class ProductReference < ApplicationRecord
  belongs_to :product_category
  has_many :products, dependent: :destroy

  validates :product_category, presence: true
end
