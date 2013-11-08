require 'spec_helper'

describe AppsHelper do
  describe '#links_to_charts' do
    it "returns error message when passed nil" do
      res = helper.link_to_charts(nil)
      res.should == I18n.t('messages.charts.not_found')
    end

    it "returns chart path when passed an app" do
      app = create(:app, charts: [build(:chart)])

      res = helper.link_to_charts(app)
      res.should include app_stat_path(app)
    end
  end
end