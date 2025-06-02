class Province < ApplicationRecord
  belongs_to :country
  has_many :cities, dependent: :destroy

  # Validaciones
  validates :name, presence: true
  # Podríamos añadir una validación para que el nombre de la provincia sea único dentro de un mismo país:
  # validates :name, uniqueness: { scope: :country_id, message: "debe ser único para este país" }
end