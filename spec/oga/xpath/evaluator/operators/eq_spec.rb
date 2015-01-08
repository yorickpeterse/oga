require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'equal operator' do
    before do
      @document = parse('<root><a>10</a><b class="foo">10</b></root>')
    end

    it 'returns true if two numbers are equal' do
      evaluate_xpath(@document, '10 = 10').should == true
    end

    it 'returns false if two numbers are not equal' do
      evaluate_xpath(@document, '10 = 15').should == false
    end

    it 'returns true if a number and a string are equal' do
      evaluate_xpath(@document, '10 = "10"').should == true
    end

    it 'returns true if two strings are equal' do
      evaluate_xpath(@document, '"10" = "10"').should == true
    end

    it 'returns true if a string and a number are equal' do
      evaluate_xpath(@document, '"10" = 10').should == true
    end

    it 'returns false if two strings are not equal' do
      evaluate_xpath(@document, '"a" = "b"').should == false
    end

    it 'returns true if two node sets are equal' do
      evaluate_xpath(@document, 'root/a = root/b').should == true
    end

    it 'returns false if two node sets are not equal' do
      evaluate_xpath(@document, 'root/a = root/c').should == false
    end

    it 'returns true if a node set and a number are equal' do
      evaluate_xpath(@document, 'root/a = 10').should == true
    end

    it 'returns true if a node set and a string are equal' do
      evaluate_xpath(@document, 'root/a = "10"').should == true
    end

    it 'returns true if a node set wildcard and a number are equal' do
      evaluate_xpath(@document, 'root/* = 10').should == true
    end

    it 'returns true if a number and a node set wildcard are equal' do
      evaluate_xpath(@document, '10 = root/*').should == true
    end

    it 'returns true if an attribute and string are equal' do
      evaluate_xpath(@document, 'root/b/@class = "foo"').should == true
    end
  end
end
