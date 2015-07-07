require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'number() function' do
    before do
      @document = parse('<root><a>10</a><b>10.5</b><!--10--></root>')
    end

    it 'converts a literal string to a number' do
      evaluate_xpath(@document, 'number("10")').should == 10.0
    end

    it 'converts a literal string with deciamsl to a number' do
      evaluate_xpath(@document, 'number("10.5")').should == 10.5
    end

    it 'converts boolean true to a number' do
      evaluate_xpath(@document, 'number(true())').should == 1.0
    end

    it 'converts boolean false to a number' do
      evaluate_xpath(@document, 'number(false())').should be_zero
    end

    it 'converts a node set to a number' do
      evaluate_xpath(@document, 'number(root/a)').should == 10.0
    end

    it 'converts a node set with decimals to a number' do
      evaluate_xpath(@document, 'number(root/b)').should == 10.5
    end

    it 'converts a comment to a number' do
      evaluate_xpath(@document, 'number(root/comment())').should == 10.0
    end

    it 'returns NaN for values that can not be converted to floats' do
      evaluate_xpath(@document, 'number("a")').should be_nan
    end

    it 'returns NaN for empty node sets' do
      evaluate_xpath(@document, 'number(foo)').should be_nan
    end

    it 'returns NaN for empty strings' do
      evaluate_xpath(@document, 'number("")').should be_nan
    end
  end
end
