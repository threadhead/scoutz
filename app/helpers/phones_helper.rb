module PhonesHelper
  def options_for_phones
    Phone.kinds.keys
  end
end
