module EmailMessagesHelper
  def sub_unit_emails(sub_unit)
    sub_unit.users_with_emails.map(&:name_email).join(', ')
  end
end
