class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :label_col_class
  def label_col_class
    @label_col_class = 'control-label col-md-4'
  end

  protected
    def auth_and_time_zone
      authenticate_user!
      Time.zone = current_user.time_zone || "Pacific Time (US & Canada)"
      @units = current_user.units if current_user
      set_unit

      # logger.info "CURRENT_UNIT_ID: #{session[:current_unit_id]}"
      # @current_unit = @units.where(id: session[:current_unit_id]).first || @units.first
      # logger.info "current_unit: #{@current_unit.name}"
    end


    def set_unit
      unit_id = params[:unit_id] || params[:select_default_unit] || session[:current_unit_id]
      @unit = current_user.units.where(id: unit_id).first || @units.first
      session[:current_unit_id] = @unit.id
    end

    def clean_up_passwords(object)
      object.clean_up_passwords if object.respond_to?(:clean_up_passwords)
    end


    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      render file: File.join(Rails.root, 'public', '403.html'), status: 403, layout: false
      # redirect_to(request.referrer || root_path)
    end
end
