require 'spec_helper'

describe User do
  it { should have_field :name }
  it { should have_field :email }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
end
