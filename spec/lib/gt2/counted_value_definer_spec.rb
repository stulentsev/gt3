require "spec_helper"

describe Gt2::CountedValueDefiner do
  let(:definer) { Gt2::CountedValueDefiner.new }

  let(:daily_stat) {
    OpenStruct.new(
        counts: {
            "referer" => {
                "menu"         => {"total" => 10},
                "notification" => {"total" => 11},
                "catalog"      => {"total" => 12},
            }
        }
    )
  }

  it "extracts total and unique counters" do
    definer.call(daily_stat).should == {
        "referer.menu.total"         => 10,
        "referer.notification.total" => 11,
        "referer.catalog.total"      => 12,
    }
  end
end