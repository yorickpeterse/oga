require 'spec_helper'

describe Oga::XML::Parser do
  context 'empty processing instructions' do
    before :all do
      @node = parse('<?foo?>').children[0]
    end

    example 'return a ProcessingInstruction instance' do
      @node.is_a?(Oga::XML::ProcessingInstruction).should == true
    end

    example 'set the name of the instruction' do
      @node.name.should == 'foo'
    end
  end

  context 'processing instructions with text' do
    before :all do
      @node = parse('<?foo bar ?>').children[0]
    end

    example 'return a ProcessingInstruction instance' do
      @node.is_a?(Oga::XML::ProcessingInstruction).should == true
    end

    example 'set the name of the instruction' do
      @node.name.should == 'foo'
    end

    example 'set the text of the instruction' do
      @node.text.should == ' bar '
    end
  end
end
