class UserConfirmationsMailer < MailerBase

  def after_email_change(user, original_email)
    @recipient = user
    @original_email = original_email

    set_time_zone(nil) # will default to Pacific

    mail to: @original_email,
         reply_to: 'info@scoutt.in',
         subject: "Email Address Change Notification"
  end

  def forced_email_change(user, user_making_change, unit)
    @recipient = user
    @user_making_change = user_making_change

    set_time_zone(unit)

    mail to: @recipient.email,
         reply_to: @user_making_change.email,
         subject: 'Email Address Change Notification'
  end
end
