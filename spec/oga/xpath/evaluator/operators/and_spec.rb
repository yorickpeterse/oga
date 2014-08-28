require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'and operator' do
    before do
      @document  = parse('<root><a>1</a><b>1</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return true if both boolean literals are true' do
      @evaluator.evaluate('true() and true()').should == true
    end

    example 'return false if one of the boolean literals is false' do
      @evaluator.evaluate('true() and false()').should == false
    end

    example 'return true if both node sets are non empty' do
      @evaluator.evaluate('root/a and root/b').should == true
    end

    example 'false false if one of the node sets is empty' do
      @evaluator.evaluate('root/a and root/c').should == false
    end

    example 'skip the right expression if the left one evaluates to false' do
      @evaluator.should_not receive(:on_call_true)

      @evaluator.evaluate('false() and true()').should == false
    end
  end
end
