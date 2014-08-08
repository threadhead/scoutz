class Ckeditor::PicturesController < Ckeditor::BaseController

  def index
    authorize Ckeditor::Picture
    @pictures = Ckeditor::Picture.where(unit_id: @unit.id).order(updated_at: :desc)

    respond_with(@pictures, layout: 'ckeditor/application')
  end


  def create
    h = Hash.new
    h[:picture] = {data: params[:upload]}
    @picture = Ckeditor::Picture.new(h[:picture])
    @picture.unit_id = params[:unit_id]
    @picture.user_id = current_user.id

    authorize @picture
    @picture.save
    # respond_with_asset(@picture)
    body = %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{@picture.data_url}');
        </script>"

    # # logger.info body
    render text: body
    # render :create, format: :txt
    # logger.info render_to_string('create.txt.haml')
    # render partial: 'create.txt.haml'
  end


  def destroy
    authorize @picture
    @picture.destroy
    redirect_to ckeditor_pictures_url
    # respond_with(@picture, :location => pictures_path)
  end



  protected
    def find_asset
      @picture = Ckeditor::Picture.find(params[:id])
    end
end
