require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'mod operator' do
    before do
      @document  = parse('<root><a>2</a><b>3</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the modulo of two numbers' do
      @evaluator.evaluate('2 mod 3').should == 2.0
    end

    example 'return the modulo of a number and a string' do
      @evaluator.evaluate('2 mod "3"').should == 2.0
    end

    example 'return the modulo of two strings' do
      @evaluator.evaluate('"2" mod "3"').should == 2.0
    end

    example 'return the modulo of a node set and a number' do
      @evaluator.evaluate('root/a mod 3').should == 2.0
    end

    example 'return the modulo of two node sets' do
      @evaluator.evaluate('root/a mod root/b').should == 2.0
    end

    example 'return NaN when trying to get the modulo of invalid values' do
      @evaluator.evaluate('"" mod 1').should be_nan
    end
  end
end
