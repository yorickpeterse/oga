require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document  = parse('<a><b></b><b></b></a>')
    @evaluator = described_class.new(@document)
  end

  context 'absolute paths' do
    before do
      @set = @evaluator.evaluate('/a')
    end

    example 'return a NodeSet instance' do
      @set.is_a?(Oga::XML::NodeSet).should == true
    end

    example 'return the right amount of nodes' do
      @set.length.should == 1
    end

    example 'return the correct nodes' do
      @set[0].should == @document.children[0]
    end
  end

  context 'relative paths' do
    before do
      @set = @evaluator.evaluate('a')
    end

    example 'return a NodeSet instance' do
      @set.is_a?(Oga::XML::NodeSet).should == true
    end

    example 'return the right amount of nodes' do
      @set.length.should == 1
    end

    example 'return the correct nodes' do
      @set[0].should == @document.children[0]
    end
  end

  context 'nested paths' do
    before do
      @set = @evaluator.evaluate('/a/b')
    end

    example 'return a NodeSet instance' do
      @set.is_a?(Oga::XML::NodeSet).should == true
    end

    example 'return the right amount of rows' do
      @set.length.should == 2
    end

    example 'return the correct nodes' do
      a = @document.children[0]

      @set[0].should == a.children[0]
      @set[1].should == a.children[1]
    end
  end
end
