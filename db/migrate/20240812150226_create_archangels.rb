class CreateArchangels < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    create_table :archangels, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :color

      t.timestamps
    end
  end
end
