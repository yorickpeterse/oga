require 'spec_helper'

describe Oga::XML::CharacterNode do
  describe '#initialize' do
    it 'sets the text in the constructor' do
      expect(described_class.new(:text => 'a').text).to eq('a')
    end

    it 'sets the text via an attribute' do
      node      = described_class.new
      node.text = 'a'

      expect(node.text).to eq('a')
    end
  end

  describe '#inspect' do
    it 'returns the inspect value' do
      expect(described_class.new(:text => 'a').inspect).to eq('CharacterNode("a")')
    end
  end
end
