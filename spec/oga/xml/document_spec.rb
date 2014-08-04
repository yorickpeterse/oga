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

  context '#each_node' do
    before do
      @document = parse(<<-EOF.strip.gsub(/\s+/m, ''))
<books>
  <book1>
    <title1>Foo</title1>
  </book1>
  <book2>
    <title2>Bar</title2>
  </book2>
</books>
      EOF
    end

    example 'yield the nodes in document order' do
      names = []

      @document.each_node do |node|
        names << (node.is_a?(Oga::XML::Element) ? node.name : node.text)
      end

      names.should == %w{books book1 title1 Foo book2 title2 Bar}
    end

    example 'skip child nodes when skip_children is thrown' do
      names = []

      @document.each_node do |node|
        if node.is_a?(Oga::XML::Element)
          if node.name == 'book1'
            throw :skip_children
          else
            names << node.name
          end
        end
      end

      names.should == %w{books book2 title2}
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
