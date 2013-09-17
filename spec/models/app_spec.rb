require 'spec_helper'

describe App do
  it { should have_field :name }
  it { should have_field :app_key }

  it { should validate_presence_of :name }

  it { should belong_to :user }


  describe '#app_key' do
    it 'is generated for new user' do
      app = FactoryGirl.build(:app)
      app.app_key.should be_nil

      app.save!
      app.app_key.should_not be_nil
    end

    it 'is not regenerated upon subsequent updates' do
      app = FactoryGirl.build(:app)
      app.save!
      old_key = app.app_key
      app.name = 'blah blah'
      app.save!
      app.app_key.should == old_key
    end
  end
end
