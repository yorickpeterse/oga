require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'greater-than operator' do
    before do
      @document  = parse('<root><a>10</a><b>20</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return true if a number is greater than another number' do
      @evaluator.evaluate('20 > 10').should == true
    end

    example 'return false if a number is not greater than another number' do
      @evaluator.evaluate('10 > 20').should == false
    end

    example 'return true if a number is greater than a string' do
      @evaluator.evaluate('20 > "10"').should == true
    end

    example 'return true if a string is greater than a number' do
      @evaluator.evaluate('"20" > 10').should == true
    end

    example 'return true if a string is greater than another string' do
      @evaluator.evaluate('"20" > "10"').should == true
    end

    example 'return true if a number is greater than a node set' do
      @evaluator.evaluate('20 > root/a').should == true
    end

    example 'return true if a string is greater than a node set' do
      @evaluator.evaluate('"20" > root/a').should == true
    end

    example 'return true if a node set is greater than another node set' do
      @evaluator.evaluate('root/b > root/a').should == true
    end
  end
end
