class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Validaciones podrían ir aquí más adelante, ej:
  # validates :status, presence: true
  # validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end