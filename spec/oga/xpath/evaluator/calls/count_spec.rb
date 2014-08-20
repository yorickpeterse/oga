require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'count() function' do
    before do
      @document  = parse('<root><a><b></b></a><a></a></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the amount of nodes as a Float' do
      @evaluator.evaluate('count(root)').is_a?(Float).should == true
    end

    example 'count the amount of <root> nodes' do
      @evaluator.evaluate('count(root)').should == 1
    end

    example 'count the amount of <a> nodes' do
      @evaluator.evaluate('count(root/a)').should == 2
    end

    example 'count the amount of <b> nodes' do
      @evaluator.evaluate('count(root/a/b)').should == 1
    end

    example 'raise ArgumentError if no arguments are given' do
      block = lambda { @evaluator.evaluate('count()') }

      block.should raise_error(ArgumentError)
    end

    example 'raise TypeError if the argument is not a NodeSet' do
      block = lambda { @evaluator.evaluate('count(1)') }

      block.should raise_error(TypeError)
    end
  end
end
