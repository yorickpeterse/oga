require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'ceiling() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    it 'returns the ceiling of a literal number' do
      evaluate_xpath(@document, 'ceiling(10.123)').should == 11.0
    end

    it 'returns the ceiling of a literal string' do
      evaluate_xpath(@document, 'ceiling("10.123")').should == 11.0
    end

    it 'returns the ceiling of a node set' do
      evaluate_xpath(@document, 'ceiling(root)').should == 11.0
    end

    it 'returns NaN for empty node sets' do
      evaluate_xpath(@document, 'ceiling(foo)').should be_nan
    end

    it 'returns NaN for an empty literal string' do
      evaluate_xpath(@document, 'ceiling("")').should be_nan
    end
  end
end
