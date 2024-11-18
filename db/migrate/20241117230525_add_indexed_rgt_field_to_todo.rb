class AddIndexedRgtFieldToTodo < ActiveRecord::Migration[8.1]
  def change
    add_index :todos, :rgt
    add_index :todos, :parent_id

    add_column :todos, :depth, :integer, default: 0
    add_column :todos, :children_count, :integer, default: 0
  end
end
