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

  def model_errors_hash(model, one_error_per_field = true)
    errors = []

    model.errors.each do |field, messages|
      fld = "#{model.class.to_s.underscore.gsub('/','_')}[#{field}]"
      if !errors.detect {|item| item[:field_name] == fld} || !one_error_per_field
        title = field.to_s
        title[0] = title[0].capitalize
        errors << {:field_display => title, :field_name => fld, :messages => messages}
      end
    end

    errors
  end
end
