class AddNestedSetColumnsToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :lft, :integer
    add_column :todos, :rgt, :integer
    add_column :todos, :parent_id, :integer
  end
end
