require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'floor() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    it 'returns the floor of a literal number' do
      expect(evaluate_xpath(@document, 'floor(10.123)')).to eq(10.0)
    end

    it 'returns the floor of a literal string' do
      expect(evaluate_xpath(@document, 'floor("10.123")')).to eq(10.0)
    end

    it 'returns the floor of a node set' do
      expect(evaluate_xpath(@document, 'floor(root)')).to eq(10.0)
    end

    it 'returns NaN for empty node sets' do
      expect(evaluate_xpath(@document, 'floor(foo)')).to be_nan
    end

    it 'returns NaN for an empty literal string' do
      expect(evaluate_xpath(@document, 'floor("")')).to be_nan
    end
  end
end
