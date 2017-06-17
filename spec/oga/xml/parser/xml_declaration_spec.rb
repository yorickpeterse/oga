require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty XML declaration tags' do
    before :all do
      @node = parse('<?xml?>').xml_declaration
    end

    it 'returns an XmlDeclaration instance' do
      expect(@node.is_a?(Oga::XML::XmlDeclaration)).to eq(true)
    end

    it 'sets the default XML version' do
      expect(@node.version).to eq('1.0')
    end

    it 'sets the default encoding' do
      expect(@node.encoding).to eq('UTF-8')
    end
  end

  describe 'XML declaration tags with custom attributes' do
    before :all do
      @node = parse('<?xml version="1.5" encoding="foo" ?>').xml_declaration
    end

    it 'returns an XmlDeclaration instance' do
      expect(@node.is_a?(Oga::XML::XmlDeclaration)).to eq(true)
    end

    it 'sets the XML version' do
      expect(@node.version).to eq('1.5')
    end

    it 'sets the encoding' do
      expect(@node.encoding).to eq('foo')
    end
  end

  it 'parses an XML declaration inside an element' do
    document = parse('<foo><?xml ?></foo>')

    expect(document.children[0]).to be_an_instance_of(Oga::XML::Element)
    expect(document.children[0].children[0]).to be_an_instance_of(Oga::XML::XmlDeclaration)
  end

  it 'parses an XML declaration preceded by an element' do
    document = parse('<foo /><?xml ?>')

    expect(document.xml_declaration).to be_an_instance_of(Oga::XML::XmlDeclaration)
    expect(document.children[0]).to be_an_instance_of(Oga::XML::Element)
  end

  it 'parses an XML declaration preceded by an element with a common ancestor' do
    document = parse('<root><a /><?xml ?></root>')
    root = document.children[0]

    expect(root.children[0]).to be_an_instance_of(Oga::XML::Element)
    expect(root.children[1]).to be_an_instance_of(Oga::XML::XmlDeclaration)

    expect(root.children[1].previous).to eq(root.children[0])
  end
end
