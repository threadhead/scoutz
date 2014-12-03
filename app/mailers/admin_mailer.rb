class AdminMailer < ActionMailer::Base
  default from: "noreply@scoutt.in"

  def send_existing_user_welcome(user_id:, token:)
    @user = User.find(user_id)
    @token = token

    mail to: @user.email,
         subject: "Welcome to Scoutt.in!"
  end
end
