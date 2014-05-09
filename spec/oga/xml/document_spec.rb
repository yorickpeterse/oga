require 'spec_helper'

describe Oga::XML::Document do
  context 'setting attributes' do
    example 'set the child nodes via the constructor' do
      children = [Oga::XML::Comment.new(:text => 'foo')]
      document = described_class.new(:children => children)

      document.children.should == children
    end

    example 'set the child nodes via a setter' do
      children = [Oga::XML::Comment.new(:text => 'foo')]
      document = described_class.new

      document.children = children

      document.children.should == children
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

    example 'pretty-print the node' do
      @instance.inspect.should == <<-EOF.strip
Document(
  doctype: Doctype(
    name: "html"
    type: nil
    public_id: nil
    system_id: nil
    inline_rules: nil
  )
  xml_declaration: XmlDeclaration(
    version: "1.0"
    encoding: "UTF-8"
    standalone: nil
  )
  children: [
    Comment(text: "foo")
])
      EOF
    end

    example 'pretty-print a document without a doctype and XML declaration' do
      described_class.new.inspect.should == <<-EOF.strip
Document(
  doctype: nil
  xml_declaration: nil
  children: [

])
      EOF
    end
  end
end
