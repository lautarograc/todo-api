class NotificationJob < ApplicationJob
  queue_as :default

  def perform(todo_id)
    todo = Todo.find(todo_id)
    NotificationAdapter.new.notify_due_date(todo)
  end
end
