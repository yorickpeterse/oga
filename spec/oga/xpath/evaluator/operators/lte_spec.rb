require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'lower-than-or-equal operator' do
    before do
      @document  = parse('<root><a>10</a><b>20</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return true if a number is lower than another number' do
      @evaluator.evaluate('10 <= 20').should == true
    end

    example 'return true if a number is equal to another number' do
      @evaluator.evaluate('10 <= 10').should == true
    end

    example 'return false if a number is not lower than/equal to another number' do
      @evaluator.evaluate('20 <= 10').should == false
    end

    example 'return true if a number is lower than a string' do
      @evaluator.evaluate('10 <= "20"').should == true
    end

    example 'return true if a number is equal to a string' do
      @evaluator.evaluate('10 <= "10"').should == true
    end

    example 'return true if a string is lower than a number' do
      @evaluator.evaluate('"10" <= 20').should == true
    end

    example 'return true if a string is equal to a number' do
      @evaluator.evaluate('"10" <= 10').should == true
    end

    example 'return true if a string is lower than another string' do
      @evaluator.evaluate('"10" <= "20"').should == true
    end

    example 'return true if a number is lower than a node set' do
      @evaluator.evaluate('10 <= root/b').should == true
    end

    example 'return true if a number is equal to a node set' do
      @evaluator.evaluate('10 <= root/a').should == true
    end

    example 'return true if a string is lower than a node set' do
      @evaluator.evaluate('"10" <= root/b').should == true
    end

    example 'return true if a string is equal to a node set' do
      @evaluator.evaluate('"10" <= root/a').should == true
    end

    example 'return true if a node set is lower than another node set' do
      @evaluator.evaluate('root/a <= root/b').should == true
    end

    example 'return true if a node set is equal to another node set' do
      @evaluator.evaluate('root/b <= root/b').should == true
    end
  end
end
