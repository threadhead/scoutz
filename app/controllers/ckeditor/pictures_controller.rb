class Ckeditor::PicturesController < Ckeditor::BaseController

  def index
    authorize Ckeditor::Picture
    @pictures = Ckeditor::Picture.find_all(ckeditor_pictures_scope)
    @pictures = Ckeditor::Paginatable.new(@pictures).page(params[:page])

    respond_with(@pictures, :layout => @pictures.first_page?)
  end

  def create
    h = Hash.new
    h[:picture] = {data: params[:upload]}
    # logger.info h.inspect
    @picture = Ckeditor::Picture.new(h[:picture])
    @picture.unit_id = params[:unit_id]
    @picture.user_id = current_user.id

    authorize @picture
    @picture.save
    # logger.info @picture.inspect
    # respond_with_asset(@picture)
    body = %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{@picture.data_url}');
        </script>"

    # logger.info body
    render text: body
  end

  def destroy
    authorize @picture
    @picture.destroy
    respond_with(@picture, :location => pictures_path)
  end

  protected

    def find_asset
      @picture = Ckeditor::Picture.get!(params[:id])
    end

    def authorize_resource
      model = (@picture || Ckeditor::Picture)
      @authorization_adapter.try(:authorize, params[:action], model)
    end
end
