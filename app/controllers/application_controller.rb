class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Disabling caching will prevent sensitive information being stored in the
  # browser cache. If your app does not deal with sensitive information then it
  # may be worth enabling caching for performance.
  before_action :authenticate_user!
  before_action :update_headers_to_disable_caching

  # A temporary redirect given a CanCan exception when accessing unauthorised
  # areas of the site (say a user tries to make a new elective)
  # This is not a definite solution but I wanted to make some tests for this anyway
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "#{exception.message}"
  end

  private
    def update_headers_to_disable_caching
      response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
      response.headers['Pragma'] = 'no-cache'
      response.headers['Expires'] = '-1'
    end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:is_wp_student])
    devise_parameter_sanitizer.permit(:account_update, keys: [:is_wp_student])
  end  
end
