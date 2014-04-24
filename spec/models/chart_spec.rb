require 'spec_helper'

describe Chart do
  it { should be_timestamped_document }

  it { should have_field :name }
  it { should have_field :config }


  it { should validate_presence_of :name }
  it { should validate_presence_of :config }

  it { should belong_to :app }

  it "converts tabs to spaces" do
    chart = create(:chart, app: create(:app))
    chart.config = "lines: \"\t\t0\""
    chart.save

    chart.config.should == 'lines: "    0"'
  end
end
