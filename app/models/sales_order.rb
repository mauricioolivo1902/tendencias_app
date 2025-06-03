# app/models/sales_order.rb
class SalesOrder < ApplicationRecord
  belongs_to :billing_address
  has_many :order_items # Un SalesOrder tiene muchos OrderItems

  # Validaciones (opcional, pero buena práctica)
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :order_number, uniqueness: true, allow_nil: true # Se generará y será único
end