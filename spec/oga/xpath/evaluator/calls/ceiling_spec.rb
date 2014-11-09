require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'ceiling() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    example 'return the ceiling of a literal number' do
      evaluate_xpath(@document, 'ceiling(10.123)').should == 11.0
    end

    example 'return the ceiling of a literal string' do
      evaluate_xpath(@document, 'ceiling("10.123")').should == 11.0
    end

    example 'return the ceiling of a node set' do
      evaluate_xpath(@document, 'ceiling(root)').should == 11.0
    end

    example 'return NaN for empty node sets' do
      evaluate_xpath(@document, 'ceiling(foo)').should be_nan
    end

    example 'return NaN for an empty literal string' do
      evaluate_xpath(@document, 'ceiling("")').should be_nan
    end
  end
end
