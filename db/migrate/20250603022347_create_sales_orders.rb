# db/migrate/YYYYMMDDHHMMSS_create_sales_orders.rb (el nombre de tu archivo exacto)
class CreateSalesOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :sales_orders do |t|
      t.references :billing_address, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status, default: 'pending' # <--- AÑADIDA ESTA PARTE
      t.string :order_number

      t.timestamps
    end
  end
end