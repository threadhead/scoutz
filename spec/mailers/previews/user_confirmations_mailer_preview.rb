# Preview all emails at http://localhost:3000/rails/mailers/user_confirmations_mailer
class UserConfirmationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_confirmations_mailer/after_email_change
  def after_email_change
    UserConfirmationsMailer.after_email_change
  end

end
