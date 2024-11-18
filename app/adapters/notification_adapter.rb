class NotificationAdapter
  def notify_due_date(todo)
    notification_strategy.notify_due_date(todo)
  end

  private

  def notification_strategy
    DatabaseNotificationStrategy.new
  end
end
