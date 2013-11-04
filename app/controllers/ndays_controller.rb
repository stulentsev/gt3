class NdaysController < ApplicationController
  before_filter :authenticate_user

  def update
    ndays = params.fetch(:ndays, 30).to_i
    current_user.update_attribute(:ndays, ndays)
    redirect_to request.referrer
  end
end