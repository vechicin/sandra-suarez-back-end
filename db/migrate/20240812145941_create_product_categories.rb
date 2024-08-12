class CreateProductCategories < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    create_table :product_categories, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
