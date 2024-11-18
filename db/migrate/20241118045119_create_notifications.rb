class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :todo, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.text :content
      t.datetime :sent_at, null: false

      t.timestamps
    end
  end
end
