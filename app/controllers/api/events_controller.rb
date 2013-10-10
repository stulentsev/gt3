class Api::EventsController < Api::ApplicationController
  def create
    SaverWorker.perform_async(params)

    render json: {status: 'ok'}
  end
end
