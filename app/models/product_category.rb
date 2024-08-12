class ProductCategory < ApplicationRecord
  self.primary_key = 'id'

  has_many :products

  validates :name, presence: true
end
