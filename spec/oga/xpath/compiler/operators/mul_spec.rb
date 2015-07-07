require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'multiplication operator' do
    before do
      @document = parse('<root><a>2</a><b>3</b></root>')
    end

    it 'multiplies two numbers' do
      evaluate_xpath(@document, '2 * 3').should == 6.0
    end

    it 'multiplies a number and a string' do
      evaluate_xpath(@document, '2 * "3"').should == 6.0
    end

    it 'multiplies two strings' do
      evaluate_xpath(@document, '"2" * "3"').should == 6.0
    end

    it 'multiplies a node set and a number' do
      evaluate_xpath(@document, 'root/a * 3').should == 6.0
    end

    it 'multiplies two node sets' do
      evaluate_xpath(@document, 'root/a * root/b').should == 6.0
    end

    it 'returns NaN when trying to multiply invalid values' do
      evaluate_xpath(@document, '"" * 1').should be_nan
    end
  end
end
