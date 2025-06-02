class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items

  # Validaciones existentes (si las tienes)
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # ... etc.
end