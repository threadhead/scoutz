class UserRelationship < ActiveRecord::Base
  belongs_to :adult, class_name: 'User'
  belongs_to :scout, class_name: 'User'
end
