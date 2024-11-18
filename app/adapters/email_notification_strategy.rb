class EmailNotificationStrategy < NotificationStrategy
  def notify_due_date(todo)
    TodoMailer.with(todo: todo).due_date_notification.deliver_now
  end
end
