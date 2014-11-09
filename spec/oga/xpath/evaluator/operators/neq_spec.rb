require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'not-equal operator' do
    before do
      @document = parse('<root><a>10</a><b>10</b></root>')
    end

    example 'return true if two numbers are not equal' do
      evaluate_xpath(@document, '10 != 20').should == true
    end

    example 'return false if two numbers are equal' do
      evaluate_xpath(@document, '10 != 10').should == false
    end

    example 'return true if a number and a string are not equal' do
      evaluate_xpath(@document, '10 != "20"').should == true
    end

    example 'return true if two strings are not equal' do
      evaluate_xpath(@document, '"10" != "20"').should == true
    end

    example 'return true if a string and a number are not equal' do
      evaluate_xpath(@document, '"10" != 20').should == true
    end

    example 'return false if two strings are equal' do
      evaluate_xpath(@document, '"a" != "a"').should == false
    end

    example 'return true if two node sets are not equal' do
      evaluate_xpath(@document, 'root != root/b').should == true
    end

    example 'return false if two node sets are equal' do
      evaluate_xpath(@document, 'root/a != root/b').should == false
    end

    example 'return true if a node set and a number are not equal' do
      evaluate_xpath(@document, 'root/a != 20').should == true
    end

    example 'return true if a node set and a string are not equal' do
      evaluate_xpath(@document, 'root/a != "20"').should == true
    end
  end
end
