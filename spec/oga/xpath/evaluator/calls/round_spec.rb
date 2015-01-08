require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'round() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    it 'returns the rounded value of a literal number' do
      evaluate_xpath(@document, 'round(10.123)').should == 10.0
    end

    it 'returns the rounded value of a literal string' do
      evaluate_xpath(@document, 'round("10.123")').should == 10.0
    end

    it 'returns the rounded value of a node set' do
      evaluate_xpath(@document, 'round(root)').should == 10.0
    end

    it 'returns NaN for empty node sets' do
      evaluate_xpath(@document, 'round(foo)').should be_nan
    end

    it 'returns NaN for an empty literal string' do
      evaluate_xpath(@document, 'round("")').should be_nan
    end
  end
end
