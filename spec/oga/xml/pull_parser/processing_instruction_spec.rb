require 'spec_helper'

describe Oga::XML::PullParser do
  describe 'processing instructions' do
    before :all do
      @parser = described_class.new('<?foo bar ?>')

      @node = nil

      @parser.parse { |node| @node = node }
    end

    it 'returns a ProcessingInstruction node' do
      expect(@node.is_a?(Oga::XML::ProcessingInstruction)).to eq(true)
    end

    it 'sets the name of the node' do
      expect(@node.name).to eq('foo')
    end

    it 'sets the text of the node' do
      expect(@node.text).to eq(' bar ')
    end
  end
end
