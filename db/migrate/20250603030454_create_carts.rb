# db/migrate/20250603030454_create_carts.rb
class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0
      t.timestamps
    end
  end
end