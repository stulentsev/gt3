require 'spec_helper'

describe EventSaver do
  let(:app) { create(:app) }
  let(:user_id) { SecureRandom.hex(8) }

  let(:default_params) {
    {
      app_id: app.id,
      method: 'track_event',
      event: 'loadApp',
      user_id: user_id
    }
  }

  describe '#valid?' do
    let(:event_params) { default_params }
    let(:result) { EventSaver.new(event_params).valid? }

    it_should_behave_like :requires_parameter, :method
    it_should_behave_like :requires_parameter, :app_id
    it_should_behave_like :requires_parameter, :event

    context 'event with subtype' do
      let(:event_params) { default_params.merge(method: 'track_value', value: 'subvalue') }
      it_should_behave_like :requires_parameter, :value
    end

    context 'numerical event' do
      let(:event_params) { default_params.merge(method: 'track_number', value: '1') }
      it_should_behave_like :requires_parameter, :value
    end
  end

  describe '#save' do
    let(:event_params) { default_params }
    subject { EventSaver.new(event_params) }

    it 'returns a status string' do
      res = subject.save

      res.should == 'ok'
    end

    it 'saves raw entry' do
      expect {
        subject.save
      }.to change{RawEntry.count}.by(1)
    end

    it 'updates total count'

    it 'updates unique count'

    describe 'event with subtype' do
      it 'updates counts for every subtype'

      it 'does not create too many subtypes'
    end

    describe 'numerical event' do
      it 'calculates aggregate values: min/max/avg/sum'
    end
  end
end