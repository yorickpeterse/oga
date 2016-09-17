require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty processing instructions' do
    before :all do
      @node = parse('<?foo?>').children[0]
    end

    it 'returns a ProcessingInstruction instance' do
      @node.is_a?(Oga::XML::ProcessingInstruction).should == true
    end

    it 'sets the name of the instruction' do
      @node.name.should == 'foo'
    end
  end

  describe 'processing instructions with text' do
    before :all do
      @node = parse('<?foo bar ?>').children[0]
    end

    it 'returns a ProcessingInstruction instance' do
      @node.is_a?(Oga::XML::ProcessingInstruction).should == true
    end

    it 'sets the name of the instruction' do
      @node.name.should == 'foo'
    end

    it 'sets the text of the instruction' do
      @node.text.should == ' bar '
    end
  end

  it 'parses a processing instruction with a namespace prefix' do
    node = parse('<?foo:bar ?>').children[0]

    node.should be_an_instance_of(Oga::XML::ProcessingInstruction)
    node.name.should == 'foo:bar'
  end
end
