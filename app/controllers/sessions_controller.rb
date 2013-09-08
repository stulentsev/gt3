class SessionsController < ApplicationController
  before_filter :authenticate_user, only: :destroy

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, :notice => "Welcome back, #{user.email}"
    else
      flash.now.alert = "Invalid email or password"
      render :new
    end
  end

  def destroy
    if current_user
      session[:user_id] = nil
    end

    redirect_to root_path, notice: "Logged out."
  end
end
