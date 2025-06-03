# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :order_items, dependent: :destroy
  # ELIMINA LA SIGUIENTE LÍNEA:
  # has_one :sales_order # Ya no necesitamos esta relación directa, los OrderItems son el vínculo
end
