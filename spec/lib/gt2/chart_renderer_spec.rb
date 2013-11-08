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
    let(:fake_data) {
      [
          DailyStat.new("stats" => {
              "load app" => {"total" => 11, "unique" => 7},
          }),
          DailyStat.new("stats" => {
              "load app" => {"total" => 21, "unique" => 8},
          }),
          DailyStat.new("stats" => {
              "load app" => {"total" => 31, "unique" => 9},
          }),
      ]
    }

    let(:chart_config) {
      OpenStruct.new(
          "lines" => [
              {
                  "name"    => "product of all loads",
                  "formula" => "[load app.total] * [load app.unique]"
              }
          ]
      )
    }

    it "evaluates formula for each daily stat" do
      rend = Gt2::ChartRenderer.new(chart_config, nil)
      rend.should_receive(:fetch_data).and_return(fake_data)

      res = rend.result
      res.should == [
          {
              name: "product of all loads",
              data: [77, 168, 279],
          }
      ]
    end
  end

  describe "#data" do
    it "gets last 30 days by default" do
      app = double(id: "foo")
      rend = Gt2::ChartRenderer.new(nil, app)

      DailyStat.should_receive(:last_n).with(30, "foo").and_return([])
      rend.data
    end

    it "gets :ndays days" do
      app = double(id: "foo")
      rend = Gt2::ChartRenderer.new(nil, app, ndays: 15)

      DailyStat.should_receive(:last_n).with(15, "foo").and_return([])
      rend.data
    end
  end
end