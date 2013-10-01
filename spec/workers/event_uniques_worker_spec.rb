require 'spec_helper'

describe EventUniquesWorker do
  let(:app) { mock_model(App) }
  let(:time) { Time.now }
  let(:params) { {app_id: app.id, time: time} }
  let(:wrapper) { double() }

  before do
    allow(Rails.configuration).to receive(:redis_wrapper).and_return(wrapper)
    expect(subject).to receive(:app_events).and_return(['event 1', 'event 2'])
  end

  it 'gets data from redis and saves to mongo' do
    expect(wrapper).to receive(:get_event_uniques).with(app.id, 'event 1', time).and_return(1)
    expect(wrapper).to receive(:get_event_uniques).with(app.id, 'event 2', time).and_return(3)

    updates = {:$set => {'stats.event 1.unique' => 1, 'stats.event 2.unique' => 3}}
    expect(DailyStat).to receive(:update_stats).with("#{app.id}_#{time.compact}", updates)

    subject.perform(params)
  end
end