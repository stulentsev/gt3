class Api::EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # TODO: pass data to service object
    render json: {status: 'ok'}
  end
end
