require 'spec_helper'

describe "Collector" do
  it 'accepts events and puts them to background queue' do
    app = create :app

    post '/api/events', app_id: app.id, token: app.app_key, event: 'load app', user_id: SecureRandom.hex
    SaverWorker.jobs.count.should == 1

    post '/api/events', app_id: app.id, token: app.app_key, event: 'load app', user_id: SecureRandom.hex
    post '/api/events', app_id: app.id, token: app.app_key, event: 'load app', user_id: SecureRandom.hex
    SaverWorker.jobs.count.should == 3
  end
end