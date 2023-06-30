class CreateResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.text :text
      t.integer :message_id

      t.timestamps
    end
  end
end
