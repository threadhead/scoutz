class SubUnit < ActiveRecord::Base
	attr_accessible :description, :name, :organization_id

	belongs_to :organization

	validates :name,
							presence: true,
							uniqueness: { scope: :organization_id, case_sensitive: false }
end
