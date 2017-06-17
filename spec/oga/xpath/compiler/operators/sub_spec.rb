require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'subtraction operator' do
    before do
      @document = parse('<root><a>2</a><b>3</b></root>')
    end

    it 'subtracts two numbers' do
      expect(evaluate_xpath(@document, '2 - 3')).to eq(-1.0)
    end

    it 'subtracts a number and a string' do
      expect(evaluate_xpath(@document, '2 - "3"')).to eq(-1.0)
    end

    it 'subtracts two strings' do
      expect(evaluate_xpath(@document, '"2" - "3"')).to eq(-1.0)
    end

    it 'subtracts a node set and a number' do
      expect(evaluate_xpath(@document, 'root/a - 3')).to eq(-1.0)
    end

    it 'subtracts two node sets' do
      expect(evaluate_xpath(@document, 'root/a - root/b')).to eq(-1.0)
    end

    it 'returns NaN when trying to subtract invalid values' do
      expect(evaluate_xpath(@document, '"" - 1')).to be_nan
    end
  end
end
