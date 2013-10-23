# This module contains common functionality for all workers, like massaging inputs, etc
module Gt2::Worker
  extend ActiveSupport::Concern

  def app_events(app_id)
    AppEvent.where(app_id: app_id).map(&:name)
  end
end