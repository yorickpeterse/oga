require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'or operator' do
    before do
      @document = parse('<root><a>1</a><b>1</b></root>')
    end

    it 'returns true if both boolean literals are true' do
      expect(evaluate_xpath(@document, 'true() or true()')).to eq(true)
    end

    it 'returns true if one of the boolean literals is false' do
      expect(evaluate_xpath(@document, 'true() or false()')).to eq(true)
    end

    it 'returns true if the left node set is not empty' do
      expect(evaluate_xpath(@document, 'root/a or root/x')).to eq(true)
    end

    it 'returns true if the right node set is not empty' do
      expect(evaluate_xpath(@document, 'root/x or root/b')).to eq(true)
    end

    it 'returns true if both node sets are not empty' do
      expect(evaluate_xpath(@document, 'root/a or root/b')).to eq(true)
    end

    it 'returns false if both node sets are empty' do
      expect(evaluate_xpath(@document, 'root/x or root/y')).to eq(false)
    end
  end
end
