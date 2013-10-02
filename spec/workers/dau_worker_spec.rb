require 'spec_helper'

describe AuWorker::Daily do
  let(:app) { mock_model(App) }
  let(:time) { Date.today }
  let(:params) { {app_id: app.id, time: time.to_s} }
  let(:wrapper) { double() }

  before do
    allow(Rails.configuration).to receive(:redis_wrapper).and_return(wrapper)
  end

  it 'gets data from redis and saves to mongo' do
    expect(wrapper).to receive(:get_dau).with(app.id, time).and_return(21)
    expect(wrapper).to receive(:expire_dau_key).with(app.id, time)

    updates = {:$set => {'system.dau' => 21}}
    expect(DailyStat).to receive(:update_stats).with("#{app.id}_#{time.compact}", updates)

    subject.perform(params)
  end
end