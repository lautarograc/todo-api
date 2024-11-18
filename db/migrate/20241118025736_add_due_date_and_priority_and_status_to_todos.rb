class AddDueDateAndPriorityAndStatusToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :due_date, :datetime
    add_column :todos, :priority, :integer, default: 0
    add_column :todos, :status, :integer, default: 0

    add_index :todos, :due_date
    add_index :todos, :priority
    add_index :todos, :status
  end
end
