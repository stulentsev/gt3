require 'spec_helper'

describe Gt2::ChartRenderer do
  let(:chart_config) {
    Gt2::ChartConfig.new("lines" => [
        {
            "name"    => "line 1",
            "formula" => "0"
        }
    ])
  }

  let(:app) { create(:app) }

  describe "#categories" do
    let(:dates) {
      [3, 2, 1].map { |x| x.days.ago.compact }
    }
    let(:fake_data) {
      dates.map do |d|
        DailyStat.new(date: d)
      end
    }
    it "returns dates of daily stats" do
      rend = Gt2::ChartRenderer.new(chart_config, app)
      rend.should_receive(:fetch_data).and_return(fake_data)

      rend.categories.should == dates
    end
  end

  describe "#result" do

  end
end