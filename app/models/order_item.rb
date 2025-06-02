class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :motivational_phrase # Si en la migración pusiste null: false para motivational_phrase_id, esta relación es obligatoria.
                                  # Si motivational_phrase_id puede ser null, podrías añadir `optional: true` aquí:
                                  # belongs_to :motivational_phrase, optional: true
                                  # Pero como sugerí hacerla obligatoria, no necesitamos `optional: true`.

  # Validaciones
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than_or_equal_to: 0 }
end