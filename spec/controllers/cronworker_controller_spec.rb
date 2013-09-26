require 'spec_helper'

describe CronworkerController do
  worker_types = [:dau, :mau, :event_uniques, :min_max]

  context 'when passing correct token' do
    before do
      create_list(:app, 2)
    end

    after do
      Sidekiq::Worker.clear_all
    end

    worker_types.each do |job_type|
      describe "\#schedule_#{job_type}" do
        it 'should place job in a queue' do
          action_name = "schedule_#{job_type}"
          get action_name, token: CronworkerController::SECRET_TOKEN
          response.status.should == 200

          klass_name = "#{job_type}_worker"
          klass = klass_name.classify.constantize
          klass.jobs.should have(2).elements
        end
      end
    end
  end

  context 'when passing incorrect token' do
    worker_types.each do |job_type|
      describe "\#schedule_#{job_type}" do
        it 'should return an error and not place job to a queue' do
          action_name = "schedule_#{job_type}"
          get action_name, token: 'asdf'
          response.status.should == 403

          klass_name = "#{job_type}_worker"
          klass = klass_name.classify.constantize
          klass.jobs.should be_empty
        end
      end
    end
  end

end
