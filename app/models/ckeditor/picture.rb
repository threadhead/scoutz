class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CkeditorPictureUploader, mount_on: :data_file_name

  before_save :update_picture_attributes
  before_create :save_original_filename


  def url_content
    url(:content)
  end

  private
    def update_picture_attributes
      if data.present? #&& data_changed?
        self.data_content_type = data.file.content_type
        self.data_file_size = data.file.size
        # self.data_updated_at = Time.zone.now
      end
    end

    def save_original_filename
      if data.present?
        self.data_original_file_name = data.file.original_filename
      end
    end

end
