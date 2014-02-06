class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_user
    if cookies[:auth_token]
      @current_user = User.find_by_auth_token(cookies[:auth_token])
      return if @current_user.nil?
    end
  end

  def login_required
    if @current_user.nil?
      session[:remember_url] = request.url
      redirect_to '/'
    end
  end
end
