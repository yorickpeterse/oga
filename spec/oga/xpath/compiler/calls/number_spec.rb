require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'number() function' do
    before do
      @document = parse('<root><a>10</a><b>10.5</b><!--10--></root>')
    end

    it 'converts a literal string to a number' do
      expect(evaluate_xpath(@document, 'number("10")')).to eq(10.0)
    end

    it 'converts a literal string with deciamsl to a number' do
      expect(evaluate_xpath(@document, 'number("10.5")')).to eq(10.5)
    end

    it 'converts boolean true to a number' do
      expect(evaluate_xpath(@document, 'number(true())')).to eq(1.0)
    end

    it 'converts boolean false to a number' do
      expect(evaluate_xpath(@document, 'number(false())')).to be_zero
    end

    it 'converts a node set to a number' do
      expect(evaluate_xpath(@document, 'number(root/a)')).to eq(10.0)
    end

    it 'converts a node set with decimals to a number' do
      expect(evaluate_xpath(@document, 'number(root/b)')).to eq(10.5)
    end

    it 'converts a comment to a number' do
      expect(evaluate_xpath(@document, 'number(root/comment())')).to eq(10.0)
    end

    it 'returns NaN for values that can not be converted to floats' do
      expect(evaluate_xpath(@document, 'number("a")')).to be_nan
    end

    it 'returns NaN for empty node sets' do
      expect(evaluate_xpath(@document, 'number(foo)')).to be_nan
    end

    it 'returns NaN for empty strings' do
      expect(evaluate_xpath(@document, 'number("")')).to be_nan
    end
  end
end
