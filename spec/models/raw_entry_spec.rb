require 'spec_helper'

describe RawEntry do
  it { should be_timestamped_document }

  it { should have_field(:event_params).of_type(Hash) }

  it { should belong_to :app }
end