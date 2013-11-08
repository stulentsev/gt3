require "spec_helper"

describe Gt2::LineExpander do
  let(:expander) { Gt2::LineExpander.new }

  describe "#call" do
    it "does nothing if param is array" do
      arr = [1, 2, 3]
      expander.call(arr).should == arr
    end

    it "raises error if param is not a string or array" do
      expect {
        expander.call({foo: 'bar'})
      }.to raise_error
    end

    describe "top / bottom" do
      let(:current_counted_values) {
        {
            "referer" => {
                "menu" => {"total" => 10},
                "notification" => {"total" => 8},
                "catalog" => {"total" => 15},
            }
        }
      }

      it "gets top N counted values" do
        lines = "[referer.top(2)]"
        res = expander.call(lines) { current_counted_values }

        res.sort_by(&:to_a).should == [
            {
                "name" => "catalog",
                "formula" => "[referer.catalog.total]",
            },
            {
                "name" => "menu",
                "formula" => "[referer.menu.total]",
            },
        ]
      end

      it "gets bottom N counted values" do
        lines = "[referer.bottom(2)]"
        res = expander.call(lines) { current_counted_values }

        res.sort_by(&:to_a).should == [
            {
                "name" => "menu",
                "formula" => "[referer.menu.total]",
            },
            {
                "name" => "notification",
                "formula" => "[referer.notification.total]",
            },
        ]
      end

      it "raises error on unrecognized method" do
        expect {
          lines = "[referer.average(2)]"
          expander.call(lines) { current_counted_values }
        }.to raise_error
      end

    end
  end
end