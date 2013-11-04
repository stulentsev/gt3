class PasswordsController < ApplicationController
  before_filter :authenticate_user

  def update
    pwd = params[:password]

    return unless all_fields_present?(pwd)
    return unless passwords_equal?(pwd)
    return unless current_password_valid?(pwd)

    update_password(pwd)

    redirect_to profile_path, notice: I18n.t('passwords.notices.updated')
  end

  private
  def all_fields_present?(pwd_hash)
    all_present = [:old_password, :password, :password_confirmation].all? do |field|
      pwd_hash[field].present?
    end

    if all_present
      true
    else
      flash[:error] = I18n.t('passwords.notices.empty')
      render :edit
      false
    end
  end

  def passwords_equal?(pwd_hash)
    if pwd_hash[:password] == pwd_hash[:password_confirmation]
      true
    else
      flash[:error] = I18n.t('passwords.notices.not_equal')
      render :edit
      false
    end
  end

  def current_password_valid?(pwd_hash)
    if current_user.authenticate(pwd_hash[:old_password])
      true
    else
      flash[:error] = I18n.t('passwords.notices.current_password_invalid')
      render :edit
      false
    end
  end

  def update_password(pwd_hash)
    current_user.password = pwd_hash[:password]
    current_user.password_confirmation = pwd_hash[:password_confirmation]
    current_user.save!
  end
end
