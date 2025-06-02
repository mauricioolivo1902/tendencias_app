class CreateMotivationalPhrases < ActiveRecord::Migration[8.0]
  def change
    create_table :motivational_phrases do |t|
      t.text :content

      t.timestamps
    end
  end
end
