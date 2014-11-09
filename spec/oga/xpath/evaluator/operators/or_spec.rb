require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'or operator' do
    before do
      @document = parse('<root><a>1</a><b>1</b></root>')
    end

    example 'return true if both boolean literals are true' do
      evaluate_xpath(@document, 'true() or true()').should == true
    end

    example 'return true if one of the boolean literals is false' do
      evaluate_xpath(@document, 'true() or false()').should == true
    end

    example 'return true if the left node set is not empty' do
      evaluate_xpath(@document, 'root/a or root/x').should == true
    end

    example 'return true if the right node set is not empty' do
      evaluate_xpath(@document, 'root/x or root/b').should == true
    end

    example 'return true if both node sets are not empty' do
      evaluate_xpath(@document, 'root/a or root/b').should == true
    end

    example 'return false if both node sets are empty' do
      evaluate_xpath(@document, 'root/x or root/y').should == false
    end

    example 'skip the right expression if the left one evaluates to false' do
      evaluator = described_class.new(@document)
      evaluator.should_not receive(:on_call_false)

      evaluator.evaluate('true() or false()').should == true
    end
  end
end
