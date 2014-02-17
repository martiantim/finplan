class WelcomeController < ApplicationController

  def index
    @error = params[:error]
    @user = User.new(:email => params[:email])
  end
end