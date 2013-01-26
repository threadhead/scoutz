class Event < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :users

  attr_accessible :attire, :end_at, :kind, :location_address1, :location_address2, :location_city, :location_map_url, :location_name, :location_state, :location_zip_code, :name, :notifier_type, :organization_id, :send_reminders, :signup_deadline, :signup_required, :start_at, :user_id
end
