require 'spec_helper'

describe Oga::XML::CharacterNode do
  describe '#initialize' do
    it 'sets the text in the constructor' do
      described_class.new(:text => 'a').text.should == 'a'
    end

    it 'sets the text via an attribute' do
      node      = described_class.new
      node.text = 'a'

      node.text.should == 'a'
    end
  end

  describe '#to_xml' do
    it 'converts the node to XML' do
      described_class.new(:text => 'a').to_xml.should == 'a'
    end
  end

  describe '#inspect' do
    it 'returns the inspect value' do
      described_class.new(:text => 'a').inspect.should == 'CharacterNode("a")'
    end
  end
end
