class DatabaseNotificationStrategy < NotificationStrategy
  def notify_due_date(todo)
    NotificationService.new.create_due_date_notification(todo)
  end
end
