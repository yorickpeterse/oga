require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty processing instructions' do
    before :all do
      @node = parse('<?foo?>').children[0]
    end

    it 'returns a ProcessingInstruction instance' do
      expect(@node.is_a?(Oga::XML::ProcessingInstruction)).to eq(true)
    end

    it 'sets the name of the instruction' do
      expect(@node.name).to eq('foo')
    end
  end

  describe 'processing instructions with text' do
    before :all do
      @node = parse('<?foo bar ?>').children[0]
    end

    it 'returns a ProcessingInstruction instance' do
      expect(@node.is_a?(Oga::XML::ProcessingInstruction)).to eq(true)
    end

    it 'sets the name of the instruction' do
      expect(@node.name).to eq('foo')
    end

    it 'sets the text of the instruction' do
      expect(@node.text).to eq(' bar ')
    end
  end

  it 'parses a processing instruction with a namespace prefix' do
    node = parse('<?foo:bar ?>').children[0]

    expect(node).to be_an_instance_of(Oga::XML::ProcessingInstruction)
    expect(node.name).to eq('foo:bar')
  end
end
