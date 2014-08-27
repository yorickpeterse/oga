require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'floor() function' do
    before do
      @document  = parse('<root>10.123</root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the floor of a literal number' do
      @evaluator.evaluate('floor(10.123)').should == 10.0
    end

    example 'return the floor of a literal string' do
      @evaluator.evaluate('floor("10.123")').should == 10.0
    end

    example 'return the floor of a node set' do
      @evaluator.evaluate('floor(root)').should == 10.0
    end

    example 'return NaN for empty node sets' do
      @evaluator.evaluate('floor(foo)').should be_nan
    end

    example 'return NaN for an empty literal string' do
      @evaluator.evaluate('floor("")').should be_nan
    end
  end
end
