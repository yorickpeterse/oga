require 'spec_helper'

describe Oga::XML::ProcessingInstruction do
  describe '#initialize' do
    it 'sets the name of the node' do
      expect(described_class.new(:name => 'foo').name).to eq('foo')
    end

    it 'sets the text of the node' do
      expect(described_class.new(:text => 'foo').text).to eq('foo')
    end
  end

  describe '#to_xml' do
    it 'convers the node into XML' do
      node = described_class.new(:name => 'foo', :text => ' bar ')

      expect(node.to_xml).to eq('<?foo bar ?>')
    end
  end

  describe '#inspect' do
    it 'returns the inspect value of the node' do
      node = described_class.new(:name => 'foo', :text => ' bar ')

      expect(node.inspect).to eq('ProcessingInstruction(name: "foo" text: " bar ")')
    end
  end
end
