class Event < ActiveRecord::Base
  attr_accessible :attire, :end, :kind, :location_address1, :location_address2, :location_city, :location_map_url, :location_name, :location_state, :location_zip_code, :name, :notifier_type, :organization_id, :send_reminders, :signup_deadline, :signup_required, :start, :user_id
end
