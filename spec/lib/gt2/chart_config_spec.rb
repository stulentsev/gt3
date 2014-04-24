require "spec_helper"

describe Gt2::ChartConfig do
  subject { Gt2::ChartConfig.new({}) }

  it { should respond_to :lines }
  it { should respond_to :format_string }

  describe ".get_array" do
    it "takes single hash" do
      cc_ary = Gt2::ChartConfig.get_array("lines" => nil, "format_string" => "foo")
      cc_ary.should have(1).item

      first = cc_ary.first
      first.lines.should be_nil
      first.format_string.should == "foo"
    end

    it "takes array of hashes" do
      arr = [{"lines" => [], "format_string" => "foo"}, {"lines" => nil, "format_string" => "bar"}]
      cc_ary = Gt2::ChartConfig.get_array(arr)
      cc_ary.should have(2).items

      first = cc_ary.first
      first.lines.should == []
      first.format_string.should == "foo"

      second = cc_ary.second
      second.lines.should == nil
      second.format_string.should == "bar"
    end

    it "provides default value for format_string" do
      cc_ary = Gt2::ChartConfig.get_array("lines" => nil)
      cc_ary.should have(1).item

      first = cc_ary.first
      first.format_string.should == "{point.y}"
    end
  end
end