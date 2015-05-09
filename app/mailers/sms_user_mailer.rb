class SmsUserMailer < MailerBase
  def remind_verify
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end
end
