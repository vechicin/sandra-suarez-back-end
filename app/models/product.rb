class Product < ApplicationRecord
  belongs_to :product_category
  belongs_to :archangel

  before_save :set_composite_key

  validates :composite_key, presence: true, uniqueness: true

  def self.find_by_composite_key(product_category_id, archangel_id)
    find_by(composite_key: "#{product_category_id}-#{archangel_id}")
  end

  private

  def set_composite_key
    self.composite_key = "#{product_category_id}-#{archangel_id}"
  end
end
