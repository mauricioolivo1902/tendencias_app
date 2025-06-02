class MotivationalPhrase < ApplicationRecord
  has_many :order_items

  validates :content, presence: true # Esta validación ya la teníamos
end