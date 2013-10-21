require 'spec_helper'

describe Gt2::NameTransformer do
  describe '#current' do
    it 'transforms name to current' do
      tran = Gt2::NameTransformer.new('open rooms.current(max)')
      tran.current.should == 'open rooms.current'
    end

    it 'returns attribute if name is not currentable' do
      tran = Gt2::NameTransformer.new('open rooms.max')
      tran.current.should == 'open rooms.max'
    end
  end

  describe '#source_attribute' do
    it 'transforms name to underlying attribute' do
      tran = Gt2::NameTransformer.new('open rooms.current(max)')
      tran.source_attribute.should == 'open rooms.max'
    end

    it 'returns attribute if name is not currentable' do
      tran = Gt2::NameTransformer.new('open rooms.max')
      tran.source_attribute.should == 'open rooms.max'
    end
  end
end