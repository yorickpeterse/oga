require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'float types' do
    before do
      @document = parse('')
    end

    it 'returns a float' do
      expect(evaluate_xpath(@document, '1.2')).to eq(1.2)
    end

    it 'returns a negative float' do
      expect(evaluate_xpath(@document, '-1.2')).to eq(-1.2)
    end

    it 'returns floats as a Float' do
      expect(evaluate_xpath(@document, '1.2').is_a?(Float)).to eq(true)
    end
  end
end
