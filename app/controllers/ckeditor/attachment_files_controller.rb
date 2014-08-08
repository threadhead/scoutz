class Ckeditor::AttachmentFilesController < Ckeditor::BaseController

  def index
    authorize Ckeditor::AttachmentFile
    @attachment_files = Ckeditor::AttachmentFile.where(unit_id: @unit.id).order(updated_at: :desc)

    respond_with(@attachment_files, layout: 'ckeditor/application')
  end


  def create
    h = Hash.new
    h[:attachment_file] = {data: params[:upload]}
    @attachment_file = Ckeditor::AttachmentFile.new(h[:attachment_file])
    @attachment_file.unit_id = params[:unit_id]
    @attachment_file.user_id = current_user.id

    authorize @attachment_file
    @attachment_file.save
    # respond_with_asset(@picture)
    body = %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{@attachment_file.data_url}');
        </script>"

    # # logger.info body
    render text: body
    # render :create, format: :txt
    # logger.info render_to_string('create.txt.haml')
    # render partial: 'create.txt.haml'
  end


  def destroy
    authorize @attachment_file
    @attachment_file.destroy
    redirect_to ckeditor_attachment_files_url
    # respond_with(@picture, :location => pictures_path)
  end



  protected
    def find_asset
      @attachment_file = Ckeditor::AttachmentFile.find(params[:id])
    end
end
