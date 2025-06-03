class CreateBillingAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :identification_number
      t.string :country
      t.string :province
      t.string :city
      t.string :address
      t.string :phone_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
