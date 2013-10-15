require 'spec_helper'

describe Gt2::Utilities do
  describe '.strip_brackets' do
    it 'strips brackets and nothing more' do
      Gt2::Utilities.strip_brackets('[my first metric].total').should == 'my first metric.total'
    end
  end
end