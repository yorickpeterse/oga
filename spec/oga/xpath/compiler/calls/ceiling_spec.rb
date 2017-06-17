require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'ceiling() function' do
    before do
      @document = parse('<root>10.123</root>')
    end

    it 'returns the ceiling of a literal number' do
      expect(evaluate_xpath(@document, 'ceiling(10.123)')).to eq(11.0)
    end

    it 'returns the ceiling of a literal string' do
      expect(evaluate_xpath(@document, 'ceiling("10.123")')).to eq(11.0)
    end

    it 'returns the ceiling of a node set' do
      expect(evaluate_xpath(@document, 'ceiling(root)')).to eq(11.0)
    end

    it 'returns NaN for empty node sets' do
      expect(evaluate_xpath(@document, 'ceiling(foo)')).to be_nan
    end

    it 'returns NaN for an empty literal string' do
      expect(evaluate_xpath(@document, 'ceiling("")')).to be_nan
    end
  end
end
