require 'spec_helper'

describe EventCleanupWorker do
  let(:app_id) { Moped::BSON::ObjectId.new.to_s }

  it 'deletes inactive app events' do
    ae = create(:app_event, _id: "#{app_id}_load")
    create(:app_event, _id: "#{app_id}_old_event", updated_at: 32.days.ago)

    EventCleanupWorker.new.perform
    AppEvent.all.should == [ae]
  end

  it 'deletes subevents of inactive events' do
    create(:app_event, _id: "#{app_id}_old_event", updated_at: 32.days.ago)
    create(:app_event, _id: "#{app_id}_old_event:value one")
    create(:app_event, _id: "#{app_id}_old_event:value two")

    EventCleanupWorker.new.perform
    AppEvent.all.should == []
  end
end