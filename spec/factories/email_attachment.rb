FactoryGirl.define do
  factory :email_attachment do |f|
    f.original_file_name "attachement_file.exr"
    f.attachment { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'attachment_file.jpg')) }
  end
end
