class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase

  delegate :url, :current_path, :content_type, to: :data

  validates_presence_of :data

  validates :data,
      presence: true,
      file_size: {
        maximum: 5.megabytes.to_i
      }


  before_save :set_organization_id

  def set_organization_id
    # self.organization_id = assetable.try(:organization_id)
    self.organization_id = Organization.first.id
  end

end
