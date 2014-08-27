require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'ceiling() function' do
    before do
      @document  = parse('<root>10.123</root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the ceiling of a literal number' do
      @evaluator.evaluate('ceiling(10.123)').should == 11.0
    end

    example 'return the ceiling of a literal string' do
      @evaluator.evaluate('ceiling("10.123")').should == 11.0
    end

    example 'return the ceiling of a node set' do
      @evaluator.evaluate('ceiling(root)').should == 11.0
    end

    example 'return NaN for empty node sets' do
      @evaluator.evaluate('ceiling(foo)').should be_nan
    end

    example 'return NaN for an empty literal string' do
      @evaluator.evaluate('ceiling("")').should be_nan
    end
  end
end
