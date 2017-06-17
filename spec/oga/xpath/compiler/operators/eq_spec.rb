require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'equal operator' do
    before do
      @document = parse('<root><a>10</a><b class="foo">10</b></root>')
    end

    it 'returns true if two numbers are equal' do
      expect(evaluate_xpath(@document, '10 = 10')).to eq(true)
    end

    it 'returns true if two numbers and 1 are equal' do
      expect(evaluate_xpath(@document, '10 = 10 = 1')).to eq(true)
    end

    it 'returns false if two numbers and 0 are not equal' do
      expect(evaluate_xpath(@document, '10 = 10 = 0')).to eq(false)
    end

    it 'returns false if two numbers are not equal' do
      expect(evaluate_xpath(@document, '10 = 15')).to eq(false)
    end

    it 'returns true if a number and a string are equal' do
      expect(evaluate_xpath(@document, '10 = "10"')).to eq(true)
    end

    it 'returns true if two strings are equal' do
      expect(evaluate_xpath(@document, '"10" = "10"')).to eq(true)
    end

    it 'returns true if a string and a number are equal' do
      expect(evaluate_xpath(@document, '"10" = 10')).to eq(true)
    end

    it 'returns false if two strings are not equal' do
      expect(evaluate_xpath(@document, '"a" = "b"')).to eq(false)
    end

    it 'returns true if two node sets are equal' do
      expect(evaluate_xpath(@document, 'root/a = root/b')).to eq(true)
    end

    it 'returns true if two node sets and 1 are equal' do
      expect(evaluate_xpath(@document, 'root/a = root/b = 1')).to eq(true)
    end

    it 'returns false if two node sets and 0 are not equal' do
      expect(evaluate_xpath(@document, 'root/a = root/b = 0')).to eq(false)
    end

    it 'returns false if two node sets are not equal' do
      expect(evaluate_xpath(@document, 'root/a = root/c')).to eq(false)
    end

    it 'returns true if a node set and a number are equal' do
      expect(evaluate_xpath(@document, 'root/a = 10')).to eq(true)
    end

    it 'returns true if a node set and a string are equal' do
      expect(evaluate_xpath(@document, 'root/a = "10"')).to eq(true)
    end

    it 'returns true if a node set wildcard and a number are equal' do
      expect(evaluate_xpath(@document, 'root/* = 10')).to eq(true)
    end

    it 'returns true if a number and a node set wildcard are equal' do
      expect(evaluate_xpath(@document, '10 = root/*')).to eq(true)
    end

    it 'returns true if an attribute and string are equal' do
      expect(evaluate_xpath(@document, 'root/b/@class = "foo"')).to eq(true)
    end

    it 'returns true if an axis and a string are equal' do
      element = @document.children[0].children[1]

      expect(evaluate_xpath(element, '@class = "foo"')).to eq(true)
    end
  end
end
