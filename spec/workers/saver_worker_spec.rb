require 'spec_helper'

describe SaverWorker do
  let(:app) { create :app }
  it 'performs basic processing' do
    # basic
    SaverWorker.perform_async(event: 'load app', app_id: app.id, user_id: '3')
    SaverWorker.perform_async(event: 'load app', app_id: app.id, user_id: '3')
    SaverWorker.perform_async(event: 'load app', app_id: app.id, user_id: '4')

    # subvalue
    SaverWorker.perform_async(event: 'referrer', value: 'menu', app_id: app.id, user_id: '4')
    SaverWorker.perform_async(event: 'referrer', value: 'menu', app_id: app.id, user_id: '4')
    SaverWorker.perform_async(event: 'referrer', value: 'notification', app_id: app.id, user_id: '4')

    # numeric
    SaverWorker.perform_async(event: 'exp', value: '1', app_id: app.id, user_id: '4')
    SaverWorker.perform_async(event: 'exp', value: '3', app_id: app.id, user_id: '4')
    SaverWorker.perform_async(event: 'exp', value: '4', app_id: app.id, user_id: '4')
    SaverWorker.perform_async(event: 'exp', value: '2', app_id: app.id, user_id: '4')

    SaverWorker.drain

    MinMaxWorker.perform_async app_id: app.id, time: Time.now
    MinMaxWorker.drain

    ds = DailyStat.today_stat(app.id).first
    ds.total_count_for('load app').should == 3
    ds.unique_count_for('load app').should == 2

    ds.subvalue_total_count_for('referrer', 'menu').should == 2
    ds.subvalue_total_count_for('referrer', 'notification').should == 1

    ds.sum_for('exp').should == 10
    ds.avg_for('exp').should == 2.5
    ds.min_for('exp').should == 1
    ds.max_for('exp').should == 4
  end
end