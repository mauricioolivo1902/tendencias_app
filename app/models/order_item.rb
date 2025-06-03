# app/models/order_item.rb
class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :motivational_phrase
  belongs_to :cart, optional: true # Puede ser nulo si se mueve a una SalesOrder
  belongs_to :sales_order, optional: true # Puede ser nulo si está en el carrito

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 } # Permite 0 para eliminar
  validates :price_at_purchase, presence: true, numericality: { greater_than: 0 }
end