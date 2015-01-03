class SmsUserMailer < MailerBase
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sms_user_mailer.remind_verify.subject
  #
  def remind_verify
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
