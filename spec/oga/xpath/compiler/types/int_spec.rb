require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'integer types' do
    before do
      @document = parse('')
    end

    it 'returns an integer' do
      expect(evaluate_xpath(@document, '1')).to eq(1)
    end

    it 'returns a negative integer' do
      expect(evaluate_xpath(@document, '-2')).to eq(-2)
    end

    it 'returns integers as a Float' do
      expect(evaluate_xpath(@document, '1').is_a?(Float)).to eq(true)
    end
  end
end
