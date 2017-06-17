require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'add operator' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')
    end

    it 'adds two numbers' do
      expect(evaluate_xpath(@document, '1 + 2')).to eq(3.0)
    end

    it 'adds a number and a string' do
      expect(evaluate_xpath(@document, '1 + "2"')).to eq(3.0)
    end

    it 'adds two strings' do
      expect(evaluate_xpath(@document, '"1" + "2"')).to eq(3.0)
    end

    it 'adds a number and a node set' do
      expect(evaluate_xpath(@document, 'root/a + 2')).to eq(3.0)
    end

    it 'adds two node sets' do
      expect(evaluate_xpath(@document, 'root/a + root/b')).to eq(3.0)
    end

    it 'returns NaN when trying to add invalid values' do
      expect(evaluate_xpath(@document, '"" + 1')).to be_nan
    end
  end
end
