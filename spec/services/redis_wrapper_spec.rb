require 'spec_helper'

describe RedisWrapper do
  subject { Rails.configuration.redis_wrapper }

  let(:app_id) { rand(100) }
  let(:event) { 'some event' }

  describe '#add_event_unique/#get_event_uniques' do
    it 'isolates events (different keys for different events' do
      2.times { subject.add_event_unique app_id, event, rand(10_000) }
      4.times { subject.add_event_unique app_id, 'another event', rand(10_000) }

      subject.get_event_uniques(app_id, event).should == 2
      subject.get_event_uniques(app_id, 'another event').should == 4
    end
  end

  describe '#add_dau/#get_dau' do
    it 'saves separate daus for different apps' do
      app2_id = app_id + rand(10)
      2.times { subject.add_dau app_id, rand(10_000) }
      4.times { subject.add_dau app2_id, rand(10_000) }

      subject.get_dau(app_id).should == 2
      subject.get_dau(app2_id).should == 4
    end
  end

  describe '#add_mau/#get_mau' do
    it 'saves separate maus for different apps' do
      app2_id = app_id + rand(10)
      2.times { subject.add_mau app_id, rand(10_000) }
      4.times { subject.add_mau app2_id, rand(10_000) }

      subject.get_mau(app_id).should == 2
      subject.get_mau(app2_id).should == 4
    end
  end

  describe '#set_min_value/#get_min_value' do
    it 'sets value if no value is present' do
      subject.set_min_value(app_id, event, 2)
      subject.get_min_value(app_id, event).should == 2
    end

    it 'updates if new value is lower' do
      subject.set_min_value(app_id, event, 5)
      subject.get_min_value(app_id, event).should == 5

      subject.set_min_value(app_id, event, 2)
      subject.get_min_value(app_id, event).should == 2
    end
    
    it 'does not update if new value is greater' do
      subject.set_min_value(app_id, event, 2)
      subject.get_min_value(app_id, event).should == 2

      subject.set_min_value(app_id, event, 5)
      subject.get_min_value(app_id, event).should == 2
    end
  end
  
  describe '#set_max_value/#get_max_value' do
    it 'sets value if no value is present' do
      subject.set_max_value(app_id, event, 2)
      subject.get_max_value(app_id, event).should == 2
    end

    it 'updates if new value is greater' do
      subject.set_max_value(app_id, event, 2)
      subject.get_max_value(app_id, event).should == 2

      subject.set_max_value(app_id, event, 5)
      subject.get_max_value(app_id, event).should == 5
    end

    it 'does not update if new value is lower' do
      subject.set_max_value(app_id, event, 5)
      subject.get_max_value(app_id, event).should == 5

      subject.set_max_value(app_id, event, 2)
      subject.get_max_value(app_id, event).should == 5
    end
  end


end