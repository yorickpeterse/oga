require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'greater-than-or-equal operator' do
    before do
      @document = parse('<root><a>10</a><b>20</b></root>')
    end

    it 'returns true if a number is greater than another number' do
      evaluate_xpath(@document, '20 >= 10').should == true
    end

    it 'returns true if a number is equal to another number' do
      evaluate_xpath(@document, '10 >= 10').should == true
    end

    it 'returns false if a number is not greater than/equal to another number' do
      evaluate_xpath(@document, '10 >= 20').should == false
    end

    it 'returns true if a number is greater than a string' do
      evaluate_xpath(@document, '20 >= "10"').should == true
    end

    it 'returns true if a number is equal to a string' do
      evaluate_xpath(@document, '10 >= "10"').should == true
    end

    it 'returns true if a string is greater than a number' do
      evaluate_xpath(@document, '"20" >= 10').should == true
    end

    it 'returns true if a string is equal to a number' do
      evaluate_xpath(@document, '"10" >= 10').should == true
    end

    it 'returns true if a string is greater than another string' do
      evaluate_xpath(@document, '"20" >= "10"').should == true
    end

    it 'returns true if a number is greater than a node set' do
      evaluate_xpath(@document, '20 >= root/a').should == true
    end

    it 'returns true if a number is equal to a node set' do
      evaluate_xpath(@document, '20 >= root/b').should == true
    end

    it 'returns true if a string is greater than a node set' do
      evaluate_xpath(@document, '"20" >= root/a').should == true
    end

    it 'returns true if a string is equal to a node set' do
      evaluate_xpath(@document, '"10" >= root/a').should == true
    end

    it 'returns true if a node set is greater than another node set' do
      evaluate_xpath(@document, 'root/b >= root/a').should == true
    end

    it 'returns true if a node set is equal to another node set' do
      evaluate_xpath(@document, 'root/b >= root/b').should == true
    end
  end
end
