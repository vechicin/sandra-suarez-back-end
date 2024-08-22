class CreateArchangels < ActiveRecord::Migration[7.1]
  def change
    create_table :archangels do |t|
      t.string :name
      t.text :description
      t.string :color

      t.timestamps
    end
  end
end
