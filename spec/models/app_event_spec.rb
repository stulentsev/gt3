require 'spec_helper'

describe AppEvent do
  it { should belong_to :app }

  it { should have_field :name }
  it { should have_field :value }
  it { should have_field :top_level }
end
