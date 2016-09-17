require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty XML declaration tags' do
    before :all do
      @node = parse('<?xml?>').xml_declaration
    end

    it 'returns an XmlDeclaration instance' do
      @node.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    it 'sets the default XML version' do
      @node.version.should == '1.0'
    end

    it 'sets the default encoding' do
      @node.encoding.should == 'UTF-8'
    end
  end

  describe 'XML declaration tags with custom attributes' do
    before :all do
      @node = parse('<?xml version="1.5" encoding="foo" ?>').xml_declaration
    end

    it 'returns an XmlDeclaration instance' do
      @node.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    it 'sets the XML version' do
      @node.version.should == '1.5'
    end

    it 'sets the encoding' do
      @node.encoding.should == 'foo'
    end
  end

  it 'parses an XML declaration inside an element' do
    document = parse('<foo><?xml ?></foo>')

    document.children[0].should be_an_instance_of(Oga::XML::Element)
    document.children[0].children[0].should be_an_instance_of(Oga::XML::XmlDeclaration)
  end

  it 'parses an XML declaration preceded by an element' do
    document = parse('<foo /><?xml ?>')

    document.xml_declaration.should be_an_instance_of(Oga::XML::XmlDeclaration)
    document.children[0].should be_an_instance_of(Oga::XML::Element)
  end

  it 'parses an XML declaration preceded by an element with a common ancestor' do
    document = parse('<root><a /><?xml ?></root>')
    root = document.children[0]

    root.children[0].should be_an_instance_of(Oga::XML::Element)
    root.children[1].should be_an_instance_of(Oga::XML::XmlDeclaration)

    root.children[1].previous.should == root.children[0]
  end
end
