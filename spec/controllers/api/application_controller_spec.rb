require 'spec_helper'

describe Api::EventsController do
  let(:app) { create :app }
  let(:event) { 'load app' }

  describe 'access token authentication' do
    context 'when passing valid token' do
      let(:params) { {app_id: app.id, token: app.app_key,
                      event: event, user_id: SecureRandom.hex} }

      it 'returns HTTP 200' do
        post 'create', params
        response.status.should == 200
      end
    end


    context 'when token does not match app_id' do
      let(:params) { {app_id: app.id, token: SecureRandom.hex,
                      event: event, user_id: SecureRandom.hex} }

      it 'returns HTTP 403' do
        post 'create', params
        response.status.should == 403
      end
    end

    context 'when token or app_id is missing' do
      let(:params) { {app_id: app.id, token: SecureRandom.hex,
                      event: event, user_id: SecureRandom.hex} }

      it 'returns HTTP 400 when app_id is missing' do
        post 'create', params.except(:app_id)
        response.status.should == 400
      end

      it 'returns HTTP 400 when token is missing' do
        post 'create', params.except(:token)
        response.status.should == 400
      end
    end
  end
end