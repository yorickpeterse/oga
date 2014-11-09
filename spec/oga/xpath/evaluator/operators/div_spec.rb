require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'div operator' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')
    end

    example 'divide two numbers' do
      evaluate_xpath(@document, '1 div 2').should == 0.5
    end

    example 'divide a number and a string' do
      evaluate_xpath(@document, '1 div "2"').should == 0.5
    end

    example 'divide two strings' do
      evaluate_xpath(@document, '"1" div "2"').should == 0.5
    end

    example 'divide a number and a node set' do
      evaluate_xpath(@document, 'root/a div 2').should == 0.5
    end

    example 'divide two node sets' do
      evaluate_xpath(@document, 'root/a div root/b').should == 0.5
    end

    example 'return NaN when trying to divide invalid values' do
      evaluate_xpath(@document, '"" div 1').should be_nan
    end
  end
end
