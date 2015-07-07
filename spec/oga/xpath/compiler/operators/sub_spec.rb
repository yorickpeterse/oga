require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'subtraction operator' do
    before do
      @document = parse('<root><a>2</a><b>3</b></root>')
    end

    it 'subtracts two numbers' do
      evaluate_xpath(@document, '2 - 3').should == -1.0
    end

    it 'subtracts a number and a string' do
      evaluate_xpath(@document, '2 - "3"').should == -1.0
    end

    it 'subtracts two strings' do
      evaluate_xpath(@document, '"2" - "3"').should == -1.0
    end

    it 'subtracts a node set and a number' do
      evaluate_xpath(@document, 'root/a - 3').should == -1.0
    end

    it 'subtracts two node sets' do
      evaluate_xpath(@document, 'root/a - root/b').should == -1.0
    end

    it 'returns NaN when trying to subtract invalid values' do
      evaluate_xpath(@document, '"" - 1').should be_nan
    end
  end
end
