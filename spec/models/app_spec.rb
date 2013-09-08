require 'spec_helper'

describe App do
  it { should have_field :name }

  it { should belong_to :user }
end
