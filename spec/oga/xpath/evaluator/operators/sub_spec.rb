require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'subtraction operator' do
    before do
      @document  = parse('<root><a>2</a><b>3</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'subtract two numbers' do
      @evaluator.evaluate('2 - 3').should == -1.0
    end

    example 'subtract a number and a string' do
      @evaluator.evaluate('2 - "3"').should == -1.0
    end

    example 'subtract two strings' do
      @evaluator.evaluate('"2" - "3"').should == -1.0
    end

    example 'subtract a node set and a number' do
      @evaluator.evaluate('root/a - 3').should == -1.0
    end

    example 'subtract two node sets' do
      @evaluator.evaluate('root/a - root/b').should == -1.0
    end

    example 'return NaN when trying to subtract invalid values' do
      @evaluator.evaluate('"" - 1').should be_nan
    end
  end
end
