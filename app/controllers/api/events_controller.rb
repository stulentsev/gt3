class Api::EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    saver = EventSaver.new(params)
    status = saver.save

    render json: {status: status}
  end
end
