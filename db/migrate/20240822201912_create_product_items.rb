class CreateProductItems < ActiveRecord::Migration[7.1]
  def change
    create_table :product_items do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :quantity
      t.text :images
      t.references :product_reference, null: false, foreign_key: true
      t.references :archangel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
