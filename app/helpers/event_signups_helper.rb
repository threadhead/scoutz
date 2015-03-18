module EventSignupsHelper
  def signup_submit(event_signup)
    "#{event_signup.new_record? ? 'Sign up' : 'Update'} #{event_signup.user.first_name}"
  end

  def signup_well_class(event_signup)
    if event_signup.persisted?
      'well-signed-up'
    else
      ''
    end
  end
end
