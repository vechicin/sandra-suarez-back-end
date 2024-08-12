class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :quantity
      t.references :product_category, type: :uuid, null: false, foreign_key: true
      t.references :archangel, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
