require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'mod operator' do
    before do
      @document = parse('<root><a>2</a><b>3</b></root>')
    end

    it 'returns the modulo of two numbers' do
      expect(evaluate_xpath(@document, '2 mod 3')).to eq(2.0)
    end

    it 'returns the modulo of a number and a string' do
      expect(evaluate_xpath(@document, '2 mod "3"')).to eq(2.0)
    end

    it 'returns the modulo of two strings' do
      expect(evaluate_xpath(@document, '"2" mod "3"')).to eq(2.0)
    end

    it 'returns the modulo of a node set and a number' do
      expect(evaluate_xpath(@document, 'root/a mod 3')).to eq(2.0)
    end

    it 'returns the modulo of two node sets' do
      expect(evaluate_xpath(@document, 'root/a mod root/b')).to eq(2.0)
    end

    it 'returns NaN when trying to get the modulo of invalid values' do
      expect(evaluate_xpath(@document, '"" mod 1')).to be_nan
    end
  end
end
