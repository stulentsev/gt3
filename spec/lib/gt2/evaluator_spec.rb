require 'spec_helper'

describe Gt2::Evaluator do
  it 'gets names used in a formula' do
    ev = Gt2::Evaluator.new '[load] / [load.unique] + [revenue.sum] + [open_rooms.current(max)]'
    ev.used_names.should =~ %w{load revenue open_rooms}
  end

  context 'validation' do
    context 'valid formulae' do
      ff = ['[load.total]',
            '[load app.total]',
            '[%visit]',
            '[session-count] / [load.total]', '[my first metric] / [load.total]',
            '[soldItem.sword]',
            '[%visit.menu]',
      ]

      ff.each do |f|
        it "allows \"#{f}\"" do
          ev = Gt2::Evaluator.new(f)
          ev.should be_valid_formula
        end
      end
    end

    context 'invalid formulae' do
      ff = ['load.avc', 'load$3.total',
            'load3..total', 'soldItem.sword',
            '[load app].total',
            '[referrer.menu].total', '[movie category.science fiction].total',
      #'[session-count.sum] / load.total',
      ]

      ff.each do |f|
        it "does not allow \"#{f}\"" do
          ev = Gt2::Evaluator.new(f)
          ev.should_not be_valid_formula
        end
      end
    end
  end


  describe "#evaluate_with" do
    it 'evaluates formula with supplied values' do
      ev = Gt2::Evaluator.new '[load] / [load.unique]+[revenue.sum]'
      values = {'load' => 10, 'load.unique' => 3, 'revenue.sum' => 2.1}

      ev.evaluate_with(values).should == 5.43
    end

    context "with bracketed syntax" do
      it 'evaluates formula with supplied values (and system metrics)' do
        ev = Gt2::Evaluator.new '[session-count] + [load]'
        values = {'load' => 10, 'session-count' => 3}

        ev.evaluate_with(values).should == 13
      end

      it 'evaluates formula with names that have spaces' do
        ev = Gt2::Evaluator.new '[my first metric] + [load app.total] + [load]'
        values = {'load' => 10, 'my first metric' => 4, 'load app.total' => 1}

        ev.evaluate_with(values).should == 15
      end
    end

    it 'prefers current values if the flag is on' do
      ev = Gt2::Evaluator.new('[load.max] + [load.current(max)] + [load.current(min)]', prefer_current: true)
      values = {'load.max' => 1, 'load.current' => 7, 'load.min' => 3}

      ev.evaluate_with(values).should == 15
    end

    it 'does not prefer current values if the flag is off' do
      ev = Gt2::Evaluator.new('[load.max] + [load.current(max)] + [load.current(min)]', prefer_current: false)
      values = {'load.max' => 1, 'load.current' => 7, 'load.min' => 3}
      ev.evaluate_with(values).should == 5
    end

    it 'does not prefer current values if the flag is missing' do
      ev = Gt2::Evaluator.new('[load.max] + [load.current(max)] + [load.current(min)] * 1')
      values = {'load.max' => 1, 'load.current' => 7, 'load.min' => 3}
      ev.evaluate_with(values).should == 5
    end

    it 'raises error if value for a name was not provided' do
      expect {
        ev = Gt2::Evaluator.new '[load] / [load.unique] + [revenue.sum]'
        values = {'load' => 10, 'revenue.sum' => 2.1}
        ev.evaluate_with(values)
      }.to raise_error(Gt2::Api::Errors::NotFoundError)
    end

    it 'does not raise error if value is missing, but default value block is given' do
      ev = Gt2::Evaluator.new '[load] / [load.unique] + [revenue.sum]'
      values = {'load' => 10, 'revenue.sum' => 2.1}

      res = ev.evaluate_with(values) { 2 }
      res.should == 7.1
    end

    it "returns 0 when unexpected exception is raised" do
      ev = Gt2::Evaluator.new "[some event]"
      ev.should_receive(:unsafe_evaluate_with).and_raise("this error")

      ev.evaluate_with({}).should == 0
    end
  end
end
