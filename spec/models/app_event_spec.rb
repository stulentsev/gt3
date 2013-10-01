require 'spec_helper'

describe AppEvent do
  it { should belong_to :app }

  it { should have_field :name }
end
