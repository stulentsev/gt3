class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Gt2::Utilities


  def authenticate_user
    redirect_to login_path unless current_user
  end

  def render_json(json, http_status = :ok)
    render json: json, content_type: 'application/json', status: http_status
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
