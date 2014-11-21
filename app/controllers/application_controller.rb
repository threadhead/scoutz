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
      User.current = current_user if current_user
      set_user_units
      set_unit
      Time.zone = @unit.time_zone || current_user.time_zone || "Pacific Time (US & Canada)"

      # logger.info "CURRENT_UNIT_ID: #{session[:current_unit_id]}"
      # @current_unit = @units.where(id: session[:current_unit_id]).first || @units.first
      # logger.info "current_unit: #{@current_unit.name}"
    end


    def set_unit
      unit_id = params[:unit_id] || params[:select_default_unit] || session[:current_unit_id]
      @unit = unit_id.nil? ? @units.first : current_user.units.where(id: unit_id).first
      session[:current_unit_id] = @unit.try(:id)
    end

    def set_user_units
      @units = current_user.units if current_user
    end

    def clean_up_passwords(object)
      object.clean_up_passwords if object.respond_to?(:clean_up_passwords)
    end


    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      render file: File.join(Rails.root, 'public', '403.html'), status: 403, layout: false
      # redirect_to(request.referrer || root_path)
    end

    def after_sign_in_path_for(resource)
      set_user_units
      set_unit
      Time.zone = @unit.time_zone || current_user.time_zone || "Pacific Time (US & Canada)"
      stored_location_for(resource) || unit_events_url(@unit)
    end

end
