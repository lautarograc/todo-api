class NotificationService
  def create_due_date_notification(todo)
    todo.notifications.create!(notification_type: "due_date_reminder", sent_at: Time.current, content: "Task '#{todo.name}' is due tomorrow"
    )
  end
end
