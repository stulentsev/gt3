require 'spec_helper'

describe Gt2::NameScanner do

  context 'valid names' do
    ff = [
          '[%visit.menu]', '[soldItem.sword]',
          '[load app.total]',
          '[%visit]',
          '[session-count]',
          '[my first metric]',
    ]

    ff.each do |f|
      it "allows \"#{f}\"" do
        scanner = Gt2::NameScanner.new
        scanner.call(f).should == [f]
      end
    end
  end

  context 'invalid names' do
    ff = ['load.avc', 'load$3.total', 'load',
          'load3..total', '%visit.menu', 'soldItem.sword',
          'load.total', 'load.unique', 'load.sum', 'load.average',
    ]

    ff.each do |f|
      it "does not allow \"#{f}\"" do
        scanner = Gt2::NameScanner.new
        scanner.call(f).should == []
      end
    end
  end

end