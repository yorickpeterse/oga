require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'div operator' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')
    end

    it 'divides two numbers' do
      evaluate_xpath(@document, '1 div 2').should == 0.5
    end

    it 'divides a number and a string' do
      evaluate_xpath(@document, '1 div "2"').should == 0.5
    end

    it 'divides two strings' do
      evaluate_xpath(@document, '"1" div "2"').should == 0.5
    end

    it 'divides a number and a node set' do
      evaluate_xpath(@document, 'root/a div 2').should == 0.5
    end

    it 'divides two node sets' do
      evaluate_xpath(@document, 'root/a div root/b').should == 0.5
    end

    it 'returns NaN when trying to divide invalid values' do
      evaluate_xpath(@document, '"" div 1').should be_nan
    end
  end
end
