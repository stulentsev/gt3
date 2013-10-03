class Api::ApplicationController < ApplicationController
  skip_before_filter :verify_authenticity_token

  before_filter :verify_app_permission

  private
  def verify_app_permission
    unless params[:app_id] && params[:token]
      render_error('app_id or token is missing', 400) and return
    end

    app = App.where(_id: params[:app_id]).first
    unless app && app.app_key == params[:token]
      render_error('app_id or token is invalid', 403) and return
    end
  end
end