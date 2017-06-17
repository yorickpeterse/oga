require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'count() function' do
    before do
      @document = parse('<root><a><b></b></a><a></a></root>')
    end

    it 'returns the amount of nodes as a Float' do
      expect(evaluate_xpath(@document, 'count(root)').is_a?(Float)).to eq(true)
    end

    it 'counts the amount of <root> nodes' do
      expect(evaluate_xpath(@document, 'count(root)')).to eq(1)
    end

    it 'counts the amount of <a> nodes' do
      expect(evaluate_xpath(@document, 'count(root/a)')).to eq(2)
    end

    it 'counts the amount of <b> nodes' do
      expect(evaluate_xpath(@document, 'count(root/a/b)')).to eq(1)
    end

    it 'raises ArgumentError if no arguments are given' do
      block = -> { evaluate_xpath(@document, 'count()') }

      expect(block).to raise_error(ArgumentError)
    end

    it 'raises TypeError if the argument is not a NodeSet' do
      block = -> { evaluate_xpath(@document, 'count(1)') }

      expect(block).to raise_error(TypeError)
    end
  end
end
