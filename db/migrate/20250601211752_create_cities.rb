class CreateCities < ActiveRecord::Migration[8.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
