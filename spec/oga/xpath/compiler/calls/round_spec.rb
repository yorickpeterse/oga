require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'round() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    it 'returns the rounded value of a literal number' do
      expect(evaluate_xpath(@document, 'round(10.123)')).to eq(10.0)
    end

    it 'returns the rounded value of a literal string' do
      expect(evaluate_xpath(@document, 'round("10.123")')).to eq(10.0)
    end

    it 'returns the rounded value of a node set' do
      expect(evaluate_xpath(@document, 'round(root)')).to eq(10.0)
    end

    it 'returns NaN for empty node sets' do
      expect(evaluate_xpath(@document, 'round(foo)')).to be_nan
    end

    it 'returns NaN for an empty literal string' do
      expect(evaluate_xpath(@document, 'round("")')).to be_nan
    end
  end
end
