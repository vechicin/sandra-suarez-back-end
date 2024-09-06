class AddDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :address, :string
    add_column :orders, :state, :string
    add_column :orders, :city, :string
    add_column :orders, :status, :string
  end
end
