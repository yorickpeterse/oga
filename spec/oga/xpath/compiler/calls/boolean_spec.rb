require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'boolean() function' do
    before do
      @document = parse('<root><a>foo</a></root>')
    end

    it 'returns true for a non empty string literal' do
      expect(evaluate_xpath(@document, 'boolean("foo")')).to eq(true)
    end

    it 'returns false for an empty string' do
      expect(evaluate_xpath(@document, 'boolean("")')).to eq(false)
    end

    it 'returns true for a positive integer' do
      expect(evaluate_xpath(@document, 'boolean(10)')).to eq(true)
    end

    it 'returns true for a boolean true' do
      expect(evaluate_xpath(@document, 'boolean(true())')).to eq(true)
    end

    it 'returns false for a boolean false' do
      expect(evaluate_xpath(@document, 'boolean(false())')).to eq(false)
    end

    it 'returns true for a positive float' do
      expect(evaluate_xpath(@document, 'boolean(10.5)')).to eq(true)
    end

    it 'returns true for a negative integer' do
      expect(evaluate_xpath(@document, 'boolean(-5)')).to eq(true)
    end

    it 'returns true for a negative float' do
      expect(evaluate_xpath(@document, 'boolean(-5.2)')).to eq(true)
    end

    it 'returns false for a zero integer' do
      expect(evaluate_xpath(@document, 'boolean(0)')).to eq(false)
    end

    it 'returns false for a zero float' do
      expect(evaluate_xpath(@document, 'boolean(0.0)')).to eq(false)
    end

    it 'returns true for a non empty node set' do
      expect(evaluate_xpath(@document, 'boolean(root/a)')).to eq(true)
    end

    it 'returns false for an empty node set' do
      expect(evaluate_xpath(@document, 'boolean(root/b)')).to eq(false)
    end
  end
end
