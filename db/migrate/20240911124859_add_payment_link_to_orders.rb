class AddPaymentLinkToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_link, :string
  end
end
