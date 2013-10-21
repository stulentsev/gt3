require 'spec_helper'

describe DailyStat do
  let(:app_id) { '1' }
  let(:date) { Date.today }
  let(:doc_id) { "#{app_id}_#{date.compact}" }
  let(:event) { 'loadApp' }

  describe '.update_stats' do
    it 'creates a new document' do
      expect {
        DailyStat.update_stats(doc_id, {:$inc => {'stats.loadApp.total' => 1}})
      }.to change{DailyStat.count}.by(1)
    end

    it 'updates document' do
      ds = DailyStat.create(_id: doc_id)
      ds.app_id.should be_nil
      ds.date.should be_nil
      ds.stats.should == {}

      DailyStat.update_stats(doc_id, { :$inc => { 'stats.loadApp.total' => 1 },
                                       :$set => { app_id: app_id, date: date.compact }
      })

      ds.reload

      ds.app_id.should == app_id
      ds.date.should == date.compact
      ds.stats.should == {event => {'total' => 1}}
    end
  end

  describe '#total_count_for' do
    it 'gets total count for an event' do
      ds = DailyStat.new(stats: {event => {'total' => 3}})

      ds.total_count_for(event).should == 3
    end
  end

  describe '#unique_count_for' do
    context 'data for today' do
      it 'gets unique count for an event from redis' do
        ds = DailyStat.new(_id: doc_id, app_id: app_id, stats: {event => {'unique' => 5}})
        3.times do
          Rails.configuration.redis_wrapper.add_event_unique(app_id, event, SecureRandom.hex(8))
        end

        ds.unique_count_for(event).should == 3
      end
    end

    context 'data for previous days' do
      let(:date) { 2.days.ago }

      it 'gets unique count for an event from the document' do
        ds = DailyStat.new(_id: doc_id, stats: {event => {'unique' => 5}})

        ds.unique_count_for(event).should == 5
      end
    end
  end

  describe '#subvalue_total_count_for' do
    it 'gets total count for subvalue of an event' do
      subval = 'some subvalue'
      ds = DailyStat.new(_id: doc_id, counts: {event => {subval => {'total' => 5}}})

      ds.subvalue_total_count_for(event, subval).should == 5
    end
  end

  describe '#today_record?' do
    it 'is true for today' do
      DailyStat.new(id: doc_id).today_record?.should be_true
    end

    it 'is not true for yesterday' do
      date = 1.day.ago
      DailyStat.new(date: doc_id).today_record?.should be_false
    end
  end
end