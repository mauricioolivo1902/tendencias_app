# app/models/billing_address.rb
class BillingAddress < ApplicationRecord
  belongs_to :user, optional: true
  has_many :sales_orders # Una dirección de facturación puede tener muchas órdenes de venta

  validates :first_name, :last_name, :identification_number, :country, :province, :city, :address, :phone_number, presence: true
end