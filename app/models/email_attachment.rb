class EmailAttachment < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  before_save :update_attachment_attributes

  belongs_to :email_message

  attr_accessible :attachment, :content_type, :file_size, :original_file_name

  validates :logo,
      :presence => true,
      :file_size => {
        :maximum => 1.0.megabytes.to_i
      }

  private

    def update_attachment_attributes
      if attachment.present? && attachment_changed?
        self.content_type = attachment.file.content_type
        self.file_size = attachment.file.size
      end
    end

end
