require 'spec_helper'

describe Oga::XML::PullParser do
  describe 'processing instructions' do
    before :all do
      @parser = described_class.new('<?foo bar ?>')

      @node = nil

      @parser.parse { |node| @node = node }
    end

    it 'returns a ProcessingInstruction node' do
      @node.is_a?(Oga::XML::ProcessingInstruction).should == true
    end

    it 'sets the name of the node' do
      @node.name.should == 'foo'
    end

    it 'sets the text of the node' do
      @node.text.should == ' bar '
    end
  end
end
