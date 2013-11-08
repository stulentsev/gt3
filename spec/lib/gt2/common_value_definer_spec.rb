require "spec_helper"

describe Gt2::CommonValueDefiner do
  let(:definer) { Gt2::CommonValueDefiner.new }

  let(:daily_stat) {
    OpenStruct.new(
        stats: {
            "load app" => {"total" => 10, "unique" => 8},
            "earn xp"  => {"total" => 9, "unique" => 7},
        }
    )
  }

  it "extracts total and unique counters" do
    definer.call(daily_stat).should == {
        "load app.total"  => 10,
        "load app.unique" => 8,
        "earn xp.total"   => 9,
        "earn xp.unique"  => 7,
    }
  end
end