class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase

  delegate :url, :current_path, :content_type, to: :data

  # validates_presence_of :data
  validates :data,
      presence: true
      # file_size: {
      #   maximum: 5.megabytes.to_i
      # }

  validate :image_size_validation, if: "data?"
  def image_size_validation
    errors.add(:data, "should be less than 5M") if data.size > 5.0.megabytes.to_i
  end


  before_save :set_unit_id
  def set_unit_id
    self.unit_id = assetable.try(:unit_id)
    # self.unit_id = Unit.first.id
  end
end
