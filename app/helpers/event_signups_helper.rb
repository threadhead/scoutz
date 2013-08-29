module EventSignupsHelper
  def signup_submit(event_signup)
    "#{event_signup.new_record? ? 'Sign up' : 'Update'} #{event_signup.scout.first_name}"
  end
end
