require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'multiplication operator' do
    before do
      @document = parse('<root><a>2</a><b>3</b></root>')
    end

    example 'multiply two numbers' do
      evaluate_xpath(@document, '2 * 3').should == 6.0
    end

    example 'multiply a number and a string' do
      evaluate_xpath(@document, '2 * "3"').should == 6.0
    end

    example 'multiply two strings' do
      evaluate_xpath(@document, '"2" * "3"').should == 6.0
    end

    example 'multiply a node set and a number' do
      evaluate_xpath(@document, 'root/a * 3').should == 6.0
    end

    example 'multiply two node sets' do
      evaluate_xpath(@document, 'root/a * root/b').should == 6.0
    end

    example 'return NaN when trying to multiply invalid values' do
      evaluate_xpath(@document, '"" * 1').should be_nan
    end
  end
end
