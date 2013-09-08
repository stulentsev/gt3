require 'spec_helper'

describe HeartbeatController do
  describe 'GET index' do
    it 'returns a JSON with timestamp' do
      get :index
      json = JSON.parse(response.body)
      json['status'].should == 'ok'
      json['ts'].should be_a Fixnum
    end
  end
end
