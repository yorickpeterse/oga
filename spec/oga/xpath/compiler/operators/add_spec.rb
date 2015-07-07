require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'add operator' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')
    end

    it 'adds two numbers' do
      evaluate_xpath(@document, '1 + 2').should == 3.0
    end

    it 'adds a number and a string' do
      evaluate_xpath(@document, '1 + "2"').should == 3.0
    end

    it 'adds two strings' do
      evaluate_xpath(@document, '"1" + "2"').should == 3.0
    end

    it 'adds a number and a node set' do
      evaluate_xpath(@document, 'root/a + 2').should == 3.0
    end

    it 'adds two node sets' do
      evaluate_xpath(@document, 'root/a + root/b').should == 3.0
    end

    it 'returns NaN when trying to add invalid values' do
      evaluate_xpath(@document, '"" + 1').should be_nan
    end
  end
end
