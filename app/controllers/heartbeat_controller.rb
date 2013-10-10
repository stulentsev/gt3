class HeartbeatController < ApplicationController
  def index
    coll = Mongoid::Sessions.default[:heartbeat]
    ts = Time.now.to_i
    coll.find(_id: 1).upsert(ts: ts)

    render json: {status: 'ok', ts: ts}
  end
end
