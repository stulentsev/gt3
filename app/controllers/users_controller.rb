class UsersController < ApplicationController
  before_filter :authenticate_user

  def update
    current_user.update_attributes(permitted_params[:user])
    redirect_to profile_path, notice: I18n.t('messages.users.updated')
  end

  def profile
    @user = current_user
    @sidebar_links = {I18n.t('labels.links') => [{name: I18n.t('passwords.edit.title'), href: edit_password_path}]}
  end

  private
  def permitted_params
    params.permit(:user => [:name, :email, :password, :password_confirmation, :api_key])
  end
end
