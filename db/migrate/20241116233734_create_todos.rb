class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos do |t|
      t.string :name, null: false, limit: 120
      t.text :description
      t.string :token, null: false

      t.timestamps
    end
  end
end
