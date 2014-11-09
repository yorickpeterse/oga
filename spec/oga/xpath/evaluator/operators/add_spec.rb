require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'add operator' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')
    end

    example 'add two numbers' do
      evaluate_xpath(@document, '1 + 2').should == 3.0
    end

    example 'add a number and a string' do
      evaluate_xpath(@document, '1 + "2"').should == 3.0
    end

    example 'add two strings' do
      evaluate_xpath(@document, '"1" + "2"').should == 3.0
    end

    example 'add a number and a node set' do
      evaluate_xpath(@document, 'root/a + 2').should == 3.0
    end

    example 'add two node sets' do
      evaluate_xpath(@document, 'root/a + root/b').should == 3.0
    end

    example 'return NaN when trying to add invalid values' do
      evaluate_xpath(@document, '"" + 1').should be_nan
    end
  end
end
