require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'and operator' do
    before do
      @document = parse('<root><a>1</a><b>1</b></root>')
    end

    it 'returns true if both boolean literals are true' do
      expect(evaluate_xpath(@document, 'true() and true()')).to eq(true)
    end

    it 'returns false if one of the boolean literals is false' do
      expect(evaluate_xpath(@document, 'true() and false()')).to eq(false)
    end

    it 'returns true if both node sets are non empty' do
      expect(evaluate_xpath(@document, 'root/a and root/b')).to eq(true)
    end

    it 'returns false if one of the node sets is empty' do
      expect(evaluate_xpath(@document, 'root/a and root/c')).to eq(false)
    end
  end
end
