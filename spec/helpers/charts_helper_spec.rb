require "spec_helper"

describe ChartsHelper do
  describe "#chart_return_path" do
    it "returns to app if it is set" do
      chart = build(:chart, app: create(:app))
      helper.chart_return_path(chart).should == edit_app_path(chart.app)
    end

    it "returns to profile if app is not set" do
      chart = build(:chart, app: nil)
      helper.chart_return_path(chart).should == profile_path
    end
  end
end