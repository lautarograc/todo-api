class NotificationStrategy
  def notify_due_date(todo)
    raise NotImplementedError, "#{self.class} must implement #notify_due_date"
  end
end
