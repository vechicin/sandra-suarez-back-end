class AddCompositeKeyToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :composite_key, :string
    add_index :products, :composite_key
  end
end
