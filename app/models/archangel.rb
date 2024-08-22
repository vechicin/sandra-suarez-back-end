class Archangel < ApplicationRecord
  has_many :product_items, dependent: :destroy
end
