require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'number() function' do
    before do
      @document  = parse('<root><a>10</a><b>10.5</b><!--10--></root>')
      @evaluator = described_class.new(@document)
    end

    example 'convert a literal string to a number' do
      @evaluator.evaluate('number("10")').should == 10.0
    end

    example 'convert a literal string with deciamsl to a number' do
      @evaluator.evaluate('number("10.5")').should == 10.5
    end

    example 'convert boolean true to a number' do
      @evaluator.evaluate('number(true())').should == 1.0
    end

    example 'convert boolean false to a number' do
      @evaluator.evaluate('number(false())').should be_zero
    end

    example 'convert a node set to a number' do
      @evaluator.evaluate('number(root/a)').should == 10.0
    end

    example 'convert a node set with decimals to a number' do
      @evaluator.evaluate('number(root/b)').should == 10.5
    end

    example 'convert a comment to a number' do
      @evaluator.evaluate('number(root/comment())').should == 10.0
    end

    example 'return NaN for values that can not be converted to floats' do
      @evaluator.evaluate('number("a")').should be_nan
    end

    example 'return NaN for empty node sets' do
      @evaluator.evaluate('number(foo)').should be_nan
    end

    example 'return NaN for empty strings' do
      @evaluator.evaluate('number("")').should be_nan
    end
  end
end
