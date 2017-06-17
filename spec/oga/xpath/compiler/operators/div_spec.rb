require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'div operator' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')
    end

    it 'divides two numbers' do
      expect(evaluate_xpath(@document, '1 div 2')).to eq(0.5)
    end

    it 'divides a number and a string' do
      expect(evaluate_xpath(@document, '1 div "2"')).to eq(0.5)
    end

    it 'divides two strings' do
      expect(evaluate_xpath(@document, '"1" div "2"')).to eq(0.5)
    end

    it 'divides a number and a node set' do
      expect(evaluate_xpath(@document, 'root/a div 2')).to eq(0.5)
    end

    it 'divides two node sets' do
      expect(evaluate_xpath(@document, 'root/a div root/b')).to eq(0.5)
    end

    it 'returns NaN when trying to divide invalid values' do
      expect(evaluate_xpath(@document, '"" div 1')).to be_nan
    end
  end
end
