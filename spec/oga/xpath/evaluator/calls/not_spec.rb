require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'not() function' do
    before do
      @document  = parse('<root>foo</root>')
      @evaluator = described_class.new(@document)
    end

    example 'return false when the argument is a non-zero integer' do
      @evaluator.evaluate('not(10)').should == false
    end

    example 'return true when the argument is a zero integer' do
      @evaluator.evaluate('not(0)').should == true
    end

    example 'return false when the argument is a non-empty node set' do
      @evaluator.evaluate('not(root)').should == false
    end

    example 'return itrue when the argument is an empty node set' do
      @evaluator.evaluate('not(foo)').should == true
    end
  end
end
