class AppsController < InheritedResources::Base
  before_filter :authenticate_user

  def create
    create! { profile_path }
  end

  def destroy
    destroy! { profile_path }
  end

  private
  def permitted_params
    params.permit(:app => [:name, :user_id])
  end
end
