# db/migrate/20250603031127_create_order_items.rb (TU NUEVO ARCHIVO DE MIGRACIÓN)
class CreateOrderItems < ActiveRecord::Migration[7.1] # O [8.0] si tu Rails es más nuevo
  def change
    create_table :order_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :motivational_phrase, null: false, foreign_key: true
      t.integer :quantity, default: 1
      t.decimal :price_at_purchase, precision: 10, scale: 2

      # Referencias a Cart y SalesOrder (ambas pueden ser nulas inicialmente)
      t.references :cart, null: true, foreign_key: true # Asegúrate de que esta línea esté
      t.references :sales_order, null: true, foreign_key: true # Y esta también

      t.timestamps
    end
  end
end