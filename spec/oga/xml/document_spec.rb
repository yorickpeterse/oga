require 'spec_helper'

describe Oga::XML::Document do
  describe 'setting attributes' do
    it 'sets the child nodes via the constructor' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new(:children => [child])

      document.children[0].should == child
    end

    it 'sets the document type' do
      described_class.new(:type => :html).type.should == :html
    end
  end

  describe '#children=' do
    it 'sets the child nodes using an Array' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new

      document.children = [child]

      document.children[0].should == child
    end

    it 'sets the child nodes using a NodeSet' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new

      document.children = Oga::XML::NodeSet.new([child])

      document.children[0].should == child
    end
  end

  describe '#root_node' do
    it 'returns self' do
      doc = described_class.new

      doc.root_node.should == doc
    end
  end

  describe '#to_xml' do
    before do
      child = Oga::XML::Comment.new(:text => 'foo')
      @document = described_class.new(:children => [child])
    end

    it 'generates the corresponding XML' do
      @document.to_xml.should == '<!--foo-->'
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
      @document.to_xml
        .should == %Q{<?xml version="5.0" encoding="UTF-8" ?>\n<!--foo-->}
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
      @document.to_xml.should == %Q{<!DOCTYPE html PUBLIC>\n<!--foo-->}
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
      @document.to_xml.should == '<?xml version="5.0" encoding="UTF-8" ?>' \
        "\n<!DOCTYPE html PUBLIC>\n<!--foo-->"
    end
  end

  describe '#html?' do
    it 'returns false for an XML document' do
      described_class.new(:type => :xml).html?.should == false
    end

    it 'returns true for an HTML document' do
      described_class.new(:type => :html).html?.should == true
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
      @instance.inspect.should == <<-EOF.strip
Document(
  doctype: Doctype(name: "html")
  xml_declaration: XmlDeclaration(version: "1.0" encoding: "UTF-8")
  children: NodeSet(Comment("foo"))
)
      EOF
    end

    it 'returns the inspect value of an empty document' do
      described_class.new.inspect.should == <<-EOF.strip
Document(
  children: NodeSet()
)
      EOF
    end
  end

  describe '#literal_html_name?' do
    it 'returns false' do
      described_class.new.literal_html_name?.should == false
    end
  end
end
