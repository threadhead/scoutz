module Ckeditor::AttachmentFilesHelper
  def data_thumb_image(asset)
    case File.extname asset.data_file_name
    when '.pdf'
      '<i class="fa fa-file-pdf-o fa-5x red-color"></i>'

    when '.doc', '.docx'
      '<i class="fa fa-file-word-o fa-5x word-blue-color"></i>'

    when '.xls', '.xlsx'
      '<i class="fa fa-file-excel-o fa-5x excel-green-color"></i>'

    when '.ppt', '.pptx'
      '<i class="fa fa-file-powerpoint-o fa-5x powerpoint-orange-color"></i>'

    when '.zip', '.rar', '.tar', '.gz'
      '<i class="fa fa-file-zip-o fa-5x"></i>'

    when '.txt', '.csv', '.tab'
      '<i class="fa fa-file-text-o fa-5x"></i>'

    else
      '<i class="fa fa-file-o fa-5x"></i>'
    end
  end
end
