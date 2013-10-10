class UsersController < ApplicationController
  before_filter :authenticate_user

  def update
    ## Using params[:user] without calling user_params will throw an error because
    ## the parameters were not filtered. This is just some Rails magic.
    #@user = User.new user_params
    #if @user.save
    #  # Do whatever
    #else
    #  render action: :new
    #end
  end

  private
  def permitted_params
    params.permit(:user => [:name, :email, :password, :password_confirmation])
  end
end
