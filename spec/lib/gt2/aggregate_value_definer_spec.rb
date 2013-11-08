require "spec_helper"

describe Gt2::AggregateValueDefiner do
  let(:definer) { Gt2::AggregateValueDefiner.new }

  let(:daily_stat) {
    stats = {
        "earn xp" => {
            "min"     => 2,
            "max"     => 30,
            "sum"     => 57,
            "count"   => 8,
            "current" => 11,
        }
    }

    mock = double(DailyStat)
    mock.stub(aggs: stats)
    mock.stub(current_for: 35)
    mock
  }

  it "extracts total and unique counters" do
    definer.call(daily_stat).should == {
        "earn xp.min"     => 2,
        "earn xp.max"     => 30,
        "earn xp.sum"     => 57,
        "earn xp.average" => 7.125,
        "earn xp.current" => 35,
    }
  end
end