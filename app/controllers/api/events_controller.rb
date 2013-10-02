class Api::EventsController < Api::ApplicationController
  def create
    saver = EventSaver.new(params)
    status = saver.save

    render json: {status: status}
  end
end
