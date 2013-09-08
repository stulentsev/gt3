require 'spec_helper'

describe Chart do
  it { should have_field :name }
  it { should have_field :config }

  it { should belong_to :app }
end
