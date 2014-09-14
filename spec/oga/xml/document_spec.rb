require 'spec_helper'

describe Oga::XML::Document do
  context 'setting attributes' do
    example 'set the child nodes via the constructor' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new(:children => [child])

      document.children[0].should == child
    end
  end

  context '#children=' do
    example 'set the child nodes using an Array' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new

      document.children = [child]

      document.children[0].should == child
    end

    example 'set the child nodes using a NodeSet' do
      child    = Oga::XML::Comment.new(:text => 'foo')
      document = described_class.new

      document.children = Oga::XML::NodeSet.new([child])

      document.children[0].should == child
    end
  end

  context '#to_html' do
    before do
      @instance = described_class.new
    end

    example 'to_xml should be aliased as to_html' do
      @instance.method(:to_xml).should == @instance.method(:to_html)
    end
  end

  context '#to_xml' do
    before do
      child = Oga::XML::Comment.new(:text => 'foo')
      @document = described_class.new(:children => [child])
    end

    example 'generate the corresponding XML' do
      @document.to_xml.should == '<!--foo-->'
    end
  end

  context '#to_xml with XML declarations' do
    before do
      decl     = Oga::XML::XmlDeclaration.new(:version => '5.0')
      children = [Oga::XML::Comment.new(:text => 'foo')]

      @document = described_class.new(
        :xml_declaration => decl,
        :children        => children
      )
    end

    example 'include the XML of the declaration tag' do
      @document.to_xml
        .should == %Q{<?xml version="5.0" encoding="UTF-8" ?>\n<!--foo-->}
    end
  end

  context '#to_xml with doctypes' do
    before do
      doctype  = Oga::XML::Doctype.new(:name => 'html', :type => 'PUBLIC')
      children = [Oga::XML::Comment.new(:text => 'foo')]

      @document = described_class.new(
        :doctype  => doctype,
        :children => children
      )
    end

    example 'include the doctype' do
      @document.to_xml.should == %Q{<!DOCTYPE html PUBLIC>\n<!--foo-->}
    end
  end

  context '#to_xml with XML declarations and doctypes' do
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

    example 'include the doctype and XML declaration' do
      @document.to_xml.should == '<?xml version="5.0" encoding="UTF-8" ?>' \
        "\n<!DOCTYPE html PUBLIC>\n<!--foo-->"
    end
  end

  context '#inspect' do
    before do
      @instance = described_class.new(
        :doctype         => Oga::XML::Doctype.new(:name => 'html'),
        :xml_declaration => Oga::XML::XmlDeclaration.new,
        :children        => [Oga::XML::Comment.new(:text => 'foo')]
      )
    end

    example 'return the inspect value' do
      @instance.inspect.should == <<-EOF.strip
Document(
  doctype: Doctype(name: "html")
  xml_declaration: XmlDeclaration(version: "1.0" encoding: "UTF-8")
  children: NodeSet(Comment("foo"))
)
      EOF
    end

    example 'return the inspect value of an empty document' do
      described_class.new.inspect.should == <<-EOF.strip
Document(
  children: NodeSet()
)
      EOF
    end
  end
end
