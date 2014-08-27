require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'round() function' do
    before do
      @document  = parse('<root>10.123</root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the rounded value of a literal number' do
      @evaluator.evaluate('round(10.123)').should == 10.0
    end

    example 'return the rounded value of a literal string' do
      @evaluator.evaluate('round("10.123")').should == 10.0
    end

    example 'return the rounded value of a node set' do
      @evaluator.evaluate('round(root)').should == 10.0
    end

    example 'return NaN for empty node sets' do
      @evaluator.evaluate('round(foo)').should be_nan
    end

    example 'return NaN for an empty literal string' do
      @evaluator.evaluate('round("")').should be_nan
    end
  end
end
