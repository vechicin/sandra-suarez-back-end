class CreateProductReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :product_references do |t|
      t.string :name
      t.text :description
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
