class CreateUsers < ActiveRecord::Migration[8.0] # o la versión que uses
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :is_admin, default: false # Añadimos default: false

      t.timestamps
    end
    add_index :users, :email, unique: true # Añadimos un índice único para el email
  end
end