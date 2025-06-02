class User < ApplicationRecord
  has_secure_password

  # Validaciones
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  # La validación de 'password_confirmation' es añadida automáticamente por has_secure_password si
  # se provee un campo password_confirmation.
end