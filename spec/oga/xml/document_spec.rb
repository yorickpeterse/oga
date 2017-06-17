require 'spec_helper'

describe Oga::XML::Document do
  describe 'setting attributes' do
    it 'sets the child nodes via the constructor' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new(:children => [child])

      expect(document.children[0]).to eq(child)
    end

    it 'sets the document type' do
      expect(described_class.new(:type => :html).type).to eq(:html)
    end
  end

  describe '#children=' do
    it 'sets the child nodes using an Array' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new

      document.children = [child]

      expect(document.children[0]).to eq(child)
    end

    it 'sets the child nodes using a NodeSet' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new

      document.children = Oga::XML::NodeSet.new([child])

      expect(document.children[0]).to eq(child)
    end
  end

  describe '#root_node' do
    it 'returns self' do
      doc = described_class.new

      expect(doc.root_node).to eq(doc)
    end
  end

  describe '#to_xml' do
    before do
      child = Oga::XML::Comment.new(:text => 'foo')
      @document = described_class.new(:children => [child])
    end

    it 'generates the corresponding XML' do
      expect(@document.to_xml).to eq('<!--foo-->')
    end
  end

  describe '#to_xml with XML declarations' do
    before do
      decl     = Oga::XML::XmlDeclaration.new(:version => '5.0')
      children = [Oga::XML::Comment.new(:text => 'foo')]

      @document = described_class.new(
        :xml_declaration => decl,
        :children        => children
      )
    end

    it 'includes the XML of the declaration tag' do
      expect(@document.to_xml)
        .to eq(%Q{<?xml version="5.0" encoding="UTF-8" ?>\n<!--foo-->})
    end
  end

  describe '#to_xml with doctypes' do
    before do
      doctype  = Oga::XML::Doctype.new(:name => 'html', :type => 'PUBLIC')
      children = [Oga::XML::Comment.new(:text => 'foo')]

      @document = described_class.new(
        :doctype  => doctype,
        :children => children
      )
    end

    it 'includes the doctype' do
      expect(@document.to_xml).to eq(%Q{<!DOCTYPE html PUBLIC>\n<!--foo-->})
    end
  end

  describe '#to_xml with XML declarations and doctypes' do
    before do
      decl     = Oga::XML::XmlDeclaration.new(:version => '5.0')
      doctype  = Oga::XML::Doctype.new(:name => 'html', :type => 'PUBLIC')
      children = [Oga::XML::Comment.new(:text => 'foo')]

      @document = described_class.new(
        :doctype         => doctype,
        :xml_declaration => decl,
        :children        => children
      )
    end

    it 'includes the doctype and XML declaration' do
      expect(@document.to_xml).to eq('<?xml version="5.0" encoding="UTF-8" ?>' \
        "\n<!DOCTYPE html PUBLIC>\n<!--foo-->")
    end
  end

  describe '#html?' do
    it 'returns false for an XML document' do
      expect(described_class.new(:type => :xml).html?).to eq(false)
    end

    it 'returns true for an HTML document' do
      expect(described_class.new(:type => :html).html?).to eq(true)
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(
        :doctype         => Oga::XML::Doctype.new(:name => 'html'),
        :xml_declaration => Oga::XML::XmlDeclaration.new,
        :children        => [Oga::XML::Comment.new(:text => 'foo')]
      )
    end

    it 'returns the inspect value' do
      expect(@instance.inspect).to eq <<-EOF.strip
Document(
  doctype: Doctype(name: "html")
  xml_declaration: XmlDeclaration(version: "1.0" encoding: "UTF-8")
  children: NodeSet(Comment("foo"))
)
      EOF
    end

    it 'returns the inspect value of an empty document' do
      expect(described_class.new.inspect).to eq <<-EOF.strip
Document(
  children: NodeSet()
)
      EOF
    end
  end

  describe '#literal_html_name?' do
    it 'returns false' do
      expect(described_class.new.literal_html_name?).to eq(false)
    end
  end
end
