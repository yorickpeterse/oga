require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'floor() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    example 'return the floor of a literal number' do
      evaluate_xpath(@document, 'floor(10.123)').should == 10.0
    end

    example 'return the floor of a literal string' do
      evaluate_xpath(@document, 'floor("10.123")').should == 10.0
    end

    example 'return the floor of a node set' do
      evaluate_xpath(@document, 'floor(root)').should == 10.0
    end

    example 'return NaN for empty node sets' do
      evaluate_xpath(@document, 'floor(foo)').should be_nan
    end

    example 'return NaN for an empty literal string' do
      evaluate_xpath(@document, 'floor("")').should be_nan
    end
  end
end
