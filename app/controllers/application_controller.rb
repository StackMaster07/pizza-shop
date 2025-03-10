class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized_access
    
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email user_name role password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email user_name role password current_password])
  end

  def handle_unauthorized_access(exception)
    flash.now[:alert] = 'You are not authorized to perform this action!'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('flash-container', partial: 'shared/flash_messages'),
               status: :forbidden
      end
      format.html do
        flash[:alert] = 'You are not authorized to perform this action!'
        redirect_back fallback_location: root_path
      end
    end
  end
end
