class Country < ApplicationRecord
  has_many :provinces, dependent: :destroy

  # Validaciones (podríamos añadir más adelante, ej. unicidad del nombre)
  validates :name, presence: true, uniqueness: true
end