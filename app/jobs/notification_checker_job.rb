class NotificationCheckerJob < ApplicationJob
  queue_as :default

  def perform
    Todo.due_tomorrow.find_each do |todo|
      NotificationJob.perform_later(todo.id)
    end
  end
end
