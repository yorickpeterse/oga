require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'boolean() function' do
    before do
      @document  = parse('<root><a>foo</a></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return true for a non empty string literal' do
      @evaluator.evaluate('boolean("foo")').should == true
    end

    example 'return false for an empty string' do
      @evaluator.evaluate('boolean("")').should == false
    end

    example 'return true for a positive integer' do
      @evaluator.evaluate('boolean(10)').should == true
    end

    example 'return true for a positive float' do
      @evaluator.evaluate('boolean(10.5)').should == true
    end

    example 'return true for a negative integer' do
      @evaluator.evaluate('boolean(-5)').should == true
    end

    example 'return true for a negative float' do
      @evaluator.evaluate('boolean(-5.2)').should == true
    end

    example 'return false for a zero integer' do
      @evaluator.evaluate('boolean(0)').should == false
    end

    example 'return false for a zero float' do
      @evaluator.evaluate('boolean(0.0)').should == false
    end

    example 'return true for a non empty node set' do
      @evaluator.evaluate('boolean(root/a)').should == true
    end

    example 'return false for an empty node set' do
      @evaluator.evaluate('boolean(root/b)').should == false
    end
  end
end
