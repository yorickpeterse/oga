require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'equal operator' do
    before do
      @document  = parse('<root><a>10</a><b>10</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return true if two numbers are equal' do
      @evaluator.evaluate('10 = 10').should == true
    end

    example 'return false if two numbers are not equal' do
      @evaluator.evaluate('10 = 15').should == false
    end

    example 'return true if a number and a string are equal' do
      @evaluator.evaluate('10 = "10"').should == true
    end

    example 'return true if two strings are equal' do
      @evaluator.evaluate('"10" = "10"').should == true
    end

    example 'return true if a string and a number are equal' do
      @evaluator.evaluate('"10" = 10').should == true
    end

    example 'return false if two strings are not equal' do
      @evaluator.evaluate('"a" = "b"').should == false
    end

    example 'return true if two node sets are equal' do
      @evaluator.evaluate('root/a = root/b').should == true
    end

    example 'return false if two node sets are not equal' do
      @evaluator.evaluate('root/a = root/c').should == false
    end

    example 'return true if a node set and a number are equal' do
      @evaluator.evaluate('root/a = 10').should == true
    end

    example 'return true if a node set and a string are equal' do
      @evaluator.evaluate('root/a = "10"').should == true
    end
  end
end
