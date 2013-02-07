class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase

  delegate :url, :current_path, :content_type, to: :data

  validates_presence_of :data

  validates :data,
      presence: true,
      file_size: {
        maximum: 5.megabytes.to_i
      }


  before_save :set_unit_id

  def set_unit_id
    # self.unit_id = assetable.try(:unit_id)
    self.unit_id = Unit.first.id
  end

end
