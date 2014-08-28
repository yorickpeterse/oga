require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'div operator' do
    before do
      @document  = parse('<root><a>1</a><b>2</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'divide two numbers' do
      @evaluator.evaluate('1 div 2').should == 0.5
    end

    example 'divide a number and a string' do
      @evaluator.evaluate('1 div "2"').should == 0.5
    end

    example 'divide two strings' do
      @evaluator.evaluate('"1" div "2"').should == 0.5
    end

    example 'divide a number and a node set' do
      @evaluator.evaluate('root/a div 2').should == 0.5
    end

    example 'divide two node sets' do
      @evaluator.evaluate('root/a div root/b').should == 0.5
    end

    example 'return NaN when trying to divide invalid values' do
      @evaluator.evaluate('"" div 1').should be_nan
    end
  end
end
