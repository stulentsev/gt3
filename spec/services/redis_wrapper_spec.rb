require 'spec_helper'

describe RedisWrapper do
  describe '#add_event_unique' do
    subject { Rails.configuration.redis_wrapper }

    let(:app_id) { rand(100) }
    let(:event) { 'loadApp' }

    it 'isolates events (different keys for different events' do
      2.times { subject.add_event_unique app_id, event, rand(10_000) }
      4.times { subject.add_event_unique app_id, 'another event', rand(10_000) }

      subject.get_event_uniques(app_id, event).should == 2
      subject.get_event_uniques(app_id, 'another event').should == 4
    end
  end
end