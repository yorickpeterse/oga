require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'add operator' do
    before do
      @document  = parse('<root><a>1</a><b>2</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'add two numbers' do
      @evaluator.evaluate('1 + 2').should == 3.0
    end

    example 'add a number and a string' do
      @evaluator.evaluate('1 + "2"').should == 3.0
    end

    example 'add two strings' do
      @evaluator.evaluate('"1" + "2"').should == 3.0
    end

    example 'add a number and a node set' do
      @evaluator.evaluate('root/a + 2').should == 3.0
    end

    example 'add two node sets' do
      @evaluator.evaluate('root/a + root/b').should == 3.0
    end

    example 'return NaN when trying to add invalid values' do
      @evaluator.evaluate('"" + 1').should be_nan
    end
  end
end
