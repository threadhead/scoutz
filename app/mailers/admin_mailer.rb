class AdminMailer < MailerBase
  default from: "noreply@scoutt.in"

  def send_existing_user_welcome(user, token)
    @user = user
    @token = token

    mail to: @user.email,
         subject: "Welcome to Scoutt.in!"
  end
end
