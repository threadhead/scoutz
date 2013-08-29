class EmailAttachment < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  before_save :update_attachment_attributes
  before_create :save_original_filename

  belongs_to :email_message

  # attr_accessible :attachment, :content_type, :file_size, :original_file_name

  validates :attachment,
      :presence => true
      # :file_size => {
      #   :maximum => 1.0.megabytes.to_i
      # }

  validate :image_size_validation, :if => "attachment?"
  def image_size_validation
    errors.add(:attachment, "should be less than 1M") if attachment.size > 1.0.megabytes.to_i
  end



  private
    def save_original_filename
      # logger.info "ATTACHMENT: #{attachment.file.original_filename}"
      self.original_file_name = attachment.file.original_filename
    end

    def update_attachment_attributes
      if attachment.present? && attachment_changed?
        self.content_type = attachment.file.content_type
        self.file_size = attachment.file.size
      end
    end

end
