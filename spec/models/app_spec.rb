require 'spec_helper'

describe App do
  it { should be_timestamped_document }

  it { should have_field :name }
  it { should have_field :app_key }

  it { should validate_presence_of :name }

  it { should belong_to :user }


  describe '#app_key' do
    it 'is generated for new user' do
      app = build(:app)
      app.app_key.should_not be_nil
    end

    it 'is not regenerated upon subsequent instantiations' do
      app = create(:app)

      app2 = App.find(app.id)
      app.app_key.should == app2.app_key
    end
  end
end
