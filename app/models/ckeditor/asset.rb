class Ckeditor::Asset < ActiveRecord::Base
  self.table_name = 'ckeditor_assets'

  # belongs_to :assetable, :polymorphic => true
  # belongs_to :unit
  # belongs_to :user

  before_save :update_picture_attributes
  before_create :save_original_filename

  # validates_presence_of :data
  validates :data, presence: true
  # file_size: {
  #   maximum: 5.megabytes.to_i
  # }

  # validate :image_size_validation, if: "data?"
  # def image_size_validation
  #   errors.add(:data, "should be less than 5M") if data.size > 5.0.megabytes.to_i
  # end

  protected

    def update_picture_attributes
      if data.present? # && data_changed?
        self.data_content_type = data.file.content_type
        self.data_file_size = data.file.size
      end
    end

    def save_original_filename
      return unless data.present?
      self.data_original_file_name = data.file.original_filename
    end

end
