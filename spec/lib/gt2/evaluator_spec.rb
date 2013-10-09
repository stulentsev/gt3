require 'spec_helper'

describe Gt2::Evaluator do
  it 'gets names used in a formula' do
    ev = Gt2::Evaluator.new 'load / load.unique + revenue.sum'
    ev.used_names.should =~ %w{load revenue}
  end

  context 'validation' do

    context 'valid formulae' do
      ff = ['load.total', 'load.unique', 'load.sum', 'load.average',
            '[%visit]',
            '[session-count] / load.total', '[my first metric] / load.total',
            '[load app].total',
      ]

      ff.each do |f|
        it "allows \"#{f}\"" do
          ev = Gt2::Evaluator.new f
          ev.should be_valid_formula
        end
      end
    end

    context 'invalid formulae' do
      ff = ['load.avc', 'load$3.total',
            'load3..total', '%visit.menu', 'soldItem.sword',
            '[%visit.menu]', '[soldItem.sword]',
            '[load app.total]'
      #'[session-count.sum] / load.total',
      ]

      ff.each do |f|
        it "does not allow \"#{f}\"" do
          ev = Gt2::Evaluator.new f
          ev.should_not be_valid_formula
        end
      end
    end
  end



  it 'does not evaluate system functions' do
    expect {
      ev = Gt2::Evaluator.new 'Kernel.caller'
      ev.evaluate_with({}).should == 0
    }.to raise_error(Gt2::Api::Errors::NotFoundError)
  end

  it 'evaluates formula with supplied values' do
    ev = Gt2::Evaluator.new 'load / load.unique + revenue.sum'
    values = {'load' => 10, 'load.unique' => 3, 'revenue.sum' => 2.1}

    ev.evaluate_with(values).should == 5.43
  end

  context "with bracketed syntax" do
    it 'evaluates formula with supplied values (and system metrics)' do
      ev = Gt2::Evaluator.new '[session-count] + load'
      values = {'load' => 10, 'session-count' => 3}

      ev.evaluate_with(values).should == 13
    end

    it 'evaluates formula with names that have spaces' do
      ev = Gt2::Evaluator.new '[my first metric] + load + [load app].total'
      values = {'load' => 10, 'my first metric' => 4, 'load app.total' => 1}

      ev.evaluate_with(values).should == 15
    end
  end


  it 'raises error if value for a name was not provided' do
    expect {
      ev = Gt2::Evaluator.new 'load / load.unique + revenue.sum'
      values = {'load' => 10, 'revenue.sum' => 2.1}

      ev.evaluate_with(values).should == 5.43
    }.to raise_error(Gt2::Api::Errors::NotFoundError)
  end
end
