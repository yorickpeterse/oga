require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'round() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    example 'return the rounded value of a literal number' do
      evaluate_xpath(@document, 'round(10.123)').should == 10.0
    end

    example 'return the rounded value of a literal string' do
      evaluate_xpath(@document, 'round("10.123")').should == 10.0
    end

    example 'return the rounded value of a node set' do
      evaluate_xpath(@document, 'round(root)').should == 10.0
    end

    example 'return NaN for empty node sets' do
      evaluate_xpath(@document, 'round(foo)').should be_nan
    end

    example 'return NaN for an empty literal string' do
      evaluate_xpath(@document, 'round("")').should be_nan
    end
  end
end
