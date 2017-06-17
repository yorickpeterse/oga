require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'not-equal operator' do
    before do
      @document = parse('<root><a>10</a><b>10</b></root>')
    end

    it 'returns true if two numbers are not equal' do
      expect(evaluate_xpath(@document, '10 != 20')).to eq(true)
    end

    it 'returns false if two numbers are equal' do
      expect(evaluate_xpath(@document, '10 != 10')).to eq(false)
    end

    it 'returns true if a number and a string are not equal' do
      expect(evaluate_xpath(@document, '10 != "20"')).to eq(true)
    end

    it 'returns true if two strings are not equal' do
      expect(evaluate_xpath(@document, '"10" != "20"')).to eq(true)
    end

    it 'returns true if a string and a number are not equal' do
      expect(evaluate_xpath(@document, '"10" != 20')).to eq(true)
    end

    it 'returns false if two strings are equal' do
      expect(evaluate_xpath(@document, '"a" != "a"')).to eq(false)
    end

    it 'returns true if two node sets are not equal' do
      expect(evaluate_xpath(@document, 'root != root/b')).to eq(true)
    end

    it 'returns false if two node sets are equal' do
      expect(evaluate_xpath(@document, 'root/a != root/b')).to eq(false)
    end

    it 'returns true if a node set and a number are not equal' do
      expect(evaluate_xpath(@document, 'root/a != 20')).to eq(true)
    end

    it 'returns true if a node set and a string are not equal' do
      expect(evaluate_xpath(@document, 'root/a != "20"')).to eq(true)
    end
  end
end
