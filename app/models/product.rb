class Product < ApplicationRecord
  belongs_to :product_category
  belongs_to :archangel

  validates :product_category, presence: true
  validates :archangel, presence: true

  after_create :set_composite_key

  def self.find_by_composite_key(product_category_id, archangel_id)
    find_by(composite_key: "#{id}-#{product_category_id}-#{archangel_id}")
  end

  private

  def set_composite_key
    if composite_key.blank? && id.present?
      update_column(:composite_key, "#{id}-#{product_category_id}-#{archangel_id}")
    end
  end
end
