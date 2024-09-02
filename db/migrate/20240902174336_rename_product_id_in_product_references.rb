class RenameProductIdInProductReferences < ActiveRecord::Migration[7.1]
  def change
    rename_column :product_references, :product_id, :product_category_id

    if index_exists?(:product_references, :product_id)
      rename_index :product_references, :index_product_references_on_product_id, :index_product_references_on_product_category_id
    end

    if foreign_key_exists?(:product_references, column: :product_id)
      remove_foreign_key :product_references, column: :product_id
    end
  end
end
