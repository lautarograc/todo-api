class TodoMailer < ApplicationMailer
  def due_date_notification
    @todo = params[:todo]
    @user = @todo.user

    mail(
      to: @user&.email_address || "test@example.com",
      subject: "Task Due Tomorrow: #{@user.email_address}",
    )
  end
end
