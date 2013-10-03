require 'spec_helper'

describe EventSaver do
  let(:app) { create(:app) }
  let(:user_id) { SecureRandom.hex(8) }
  let(:event) { 'loadApp' }

  let(:default_params) {
    {
      app_id: app.id,
      event: event,
      user_id: user_id
    }
  }

  describe '#valid?' do
    let(:event_params) { default_params }
    let(:result) { EventSaver.new(event_params).valid? }

    it_should_behave_like :requires_parameter, :app_id
    it_should_behave_like :requires_parameter, :event
  end

  describe '#save' do
    let(:event_params) { default_params }
    subject { EventSaver.new(event_params) }

    before do
      redis = double().as_null_object

      Rails.configuration.stub(redis_wrapper: RedisWrapper.new(redis))
    end


    it 'returns a status string' do
      res = subject.save

      res.should == 'ok'
    end

    it 'saves raw entry' do
      expect {
        subject.save
      }.to change{RawEntry.count}.by(1)
    end

    it 'creates a new app event with proper fields' do
      expect {
        subject.save
      }.to change{AppEvent.count}.from(0).to(1)

      ae = AppEvent.first
      ae.name.should == 'loadApp'
      ae.app_id.should == app.id
      ae.top_level.should be_true
    end

    it 'does not create duplicate events' do
      expect {
        subject.save
        subject.save
      }.to change{AppEvent.count}.from(0).to(1)
    end

    describe 'forming update params' do
      let(:doc_id) { "#{app.id}_#{Time.now.compact}" }

      it 'sets app_id and date' do
        DailyStat.should_receive(:update_stats).with(doc_id, hash_including(:$set => {app_id: app.id, date: Time.now.compact}))
        subject.save
      end

      it 'updates total count' do
        DailyStat.should_receive(:update_stats).with(doc_id, hash_including(:$inc => {"stats.#{event}.total" => 1}))
        subject.save
      end

      it 'updates unique count' do
        Rails.configuration.redis_wrapper.should_receive(:add_event_unique).with(app.id, event, user_id)

        subject.save
      end

      it 'updates dau' do
        Rails.configuration.redis_wrapper.should_receive(:add_dau).with(app.id, user_id)

        subject.save
      end

      it 'updates mau' do
        Rails.configuration.redis_wrapper.should_receive(:add_mau).with(app.id, user_id)

        subject.save
      end

      describe 'event with subtype' do
        let(:event_params) {
          default_params.merge(value: 'some subvalue')
        }

        it 'updates counts for every subtype' do
          DailyStat.should_receive(:update_stats).with(doc_id, hash_including(:$inc => hash_including({"counts.#{event}.some subvalue.total" => 1})))
          subject.save
        end

        it 'creates subevent' do
          expect {
            subject.save
          }.to change{AppEvent.count}.from(0).to(2)

          ae = AppEvent.last
          ae.id.should == "#{app.id}:loadApp:some subvalue"
          ae.name.should == 'loadApp'
          ae.value.should == 'some subvalue'
          ae.app_id.should == app.id
          ae.top_level.should be_false
        end

        context 'when too many subevents' do
          before do
            # for create_app_subevent
            result = double(count: 100)
            allow(AppEvent).to receive(:where).with(app_id: app.id, name: event, top_level: false).and_return(result)
          end

          it 'does not create subevent' do
            expect {
              subject.send(:create_app_subevent)
            }.to_not change{AppEvent.count}
          end
        end
      end

      describe 'numerical event' do
        let(:event_params) {
          default_params.merge(value: '2')
        }

        it 'calculates aggregate values: min/max/avg/sum' do
          DailyStat.should_receive(:update_stats).with(doc_id,
                                                       hash_including(:$inc => hash_including({"aggs.#{event}.sum" => 2,
                                                                                 "aggs.#{event}.count" => 1})))
          subject.save
        end

        it 'updates min/max value in redis' do
          Rails.configuration.redis_wrapper.should_receive(:set_min_value).with(app.id, event, '2')
          Rails.configuration.redis_wrapper.should_receive(:set_max_value).with(app.id, event, '2')
          subject.save
        end
      end
    end
  end
end