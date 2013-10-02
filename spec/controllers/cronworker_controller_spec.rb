require 'spec_helper'

describe CronworkerController do
  worker_types = {:dau => AuWorker::Daily,
                  :mau => AuWorker::Monthly,
                  :event_uniques => EventUniquesWorker,
                  :min_max => MinMaxWorker}

  context 'when passing correct token' do
    before do
      create_list(:app, 2)
    end

    after do
      Sidekiq::Worker.clear_all
    end

    worker_types.each do |job_type, klass|
      describe "\#schedule_#{job_type}" do
        it 'should place job in a queue' do
          action_name = "schedule_#{job_type}"
          get action_name, token: CronworkerController::SECRET_TOKEN
          response.status.should == 200

          klass.jobs.should have(2).elements
        end
      end
    end
  end

  context 'when passing incorrect token' do
    worker_types.each do |job_type, klass|
      describe "\#schedule_#{job_type}" do
        it 'should return an error and not place job to a queue' do
          action_name = "schedule_#{job_type}"
          get action_name, token: 'asdf'
          response.status.should == 403

          klass.jobs.should be_empty
        end
      end
    end
  end

end
