class RenameProductItemsAndProducts < ActiveRecord::Migration[7.1]
  def change
    rename_table :products, :product_categories
    rename_table :product_items, :products
  end
end
