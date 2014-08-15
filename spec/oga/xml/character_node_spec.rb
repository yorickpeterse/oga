require 'spec_helper'

describe Oga::XML::CharacterNode do
  context '#initialize' do
    example 'set the text in the constructor' do
      described_class.new(:text => 'a').text.should == 'a'
    end

    example 'set the text via an attribute' do
      node      = described_class.new
      node.text = 'a'

      node.text.should == 'a'
    end
  end

  context '#to_xml' do
    example 'convert the node to XML' do
      described_class.new(:text => 'a').to_xml.should == 'a'
    end
  end

  context '#inspect' do
    example 'return the inspect value' do
      described_class.new(:text => 'a').inspect.should == 'CharacterNode("a")'
    end
  end
end
