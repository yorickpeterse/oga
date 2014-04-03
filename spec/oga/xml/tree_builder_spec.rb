require 'spec_helper'

describe Oga::XML::TreeBuilder do
  before do
    @builder = described_class.new
  end

  context '#on_document' do
    before do
      node = s(:document, s(:element, nil, 'p', nil, nil))
      @tag = @builder.process(node)
    end

    example 'return a Document node' do
      @tag.is_a?(Oga::XML::Document).should == true
    end

    example 'include the children of the element' do
      @tag.children[0].is_a?(Oga::XML::Element).should == true
    end
  end

  context '#on_document with XML declarations' do
    before do
      decl = s(:xml_decl, s(:attributes, s(:attribute, 'encoding', 'UTF-8')))
      node = s(:document, decl)
      @tag = @builder.process(node)
    end

    example 'set the XML declaration of the document' do
      @tag.xml_declaration.is_a?(Oga::XML::XmlDeclaration).should == true
    end
  end

  context '#on_document with doctypes' do
    before do
      doctype = s(:doctype, 'html', 'PUBLIC', 'foo', 'bar')
      node    = s(:document, doctype)
      @tag    = @builder.process(node)
    end

    example 'set the doctype of the document' do
      @tag.doctype.is_a?(Oga::XML::Doctype).should == true
    end
  end

  context '#on_xml_decl' do
    before do
      node = s(:xml_decl, s(:attributes, s(:attribute, 'encoding', 'UTF-8')))
      @tag = @builder.process(node)
    end

    example 'return an XmlDeclaration node' do
      @tag.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    example 'include the encoding of the tag' do
      @tag.encoding.should == 'UTF-8'
    end
  end

  context '#on_doctype' do
    before do
      node = s(:doctype, 'html', 'PUBLIC', 'foo', 'bar')
      @tag = @builder.process(node)
    end

    example 'return a Doctype node' do
      @tag.is_a?(Oga::XML::Doctype).should == true
    end

    example 'include the doctype name' do
      @tag.name.should == 'html'
    end

    example 'include the doctype type' do
      @tag.type.should == 'PUBLIC'
    end

    example 'include the public ID' do
      @tag.public_id.should == 'foo'
    end

    example 'include the system ID' do
      @tag.system_id.should == 'bar'
    end
  end

  context '#on_comment' do
    before do
      node = s(:comment, 'foo')
      @tag = @builder.process(node)
    end

    example 'return a Comment node' do
      @tag.is_a?(Oga::XML::Comment).should == true
    end

    example 'include the text of the comment' do
      @tag.text.should == 'foo'
    end
  end

  context '#on_element' do
    context 'simple elements' do
      before do
        node = s(:element, 'foo', 'p', nil, nil)
        @tag = @builder.process(node)
      end

      example 'return a Element node' do
        @tag.is_a?(Oga::XML::Element).should == true
      end

      example 'include the name of the element' do
        @tag.name.should == 'p'
      end

      example 'include the namespace of the element' do
        @tag.namespace.should == 'foo'
      end
    end

    context 'elements with attributes' do
      before do
        node = s(
          :element,
          nil,
          'p',
          s(:attributes, s(:attribute, 'key', 'value')),
          nil
        )

        @tag = @builder.process(node)
      end

      example 'include the name of the element' do
        @tag.name.should == 'p'
      end

      example 'include the attributes' do
        @tag.attributes.should == {'key' => 'value'}
      end
    end

    context 'elements with parent elements' do
      before do
        node = s(:element, nil, 'p', nil, s(:element, nil, 'span', nil, nil))
        @tag = @builder.process(node)
      end

      example 'set the parent element' do
        @tag.children[0].parent.should == @tag
      end
    end

    context 'elements with next elements' do
      before do
        node = s(
          :element,
          nil,
          'p',
          nil,
          s(:element, nil, 'a', nil, nil),
          s(:element, nil, 'span', nil, nil)
        )

        @tag = @builder.process(node)
      end

      example 'set the next element' do
        @tag.children[0].next.should == @tag.children[1]
      end

      example 'do not set the next element for the last element' do
        @tag.children[1].next.should == nil
      end
    end

    context 'elements with previous elements' do
      before do
        node = s(
          :element,
          nil,
          'p',
          nil,
          s(:element, nil, 'a', nil, nil),
          s(:element, nil, 'span', nil, nil)
        )

        @tag = @builder.process(node)
      end

      example 'set the previous element' do
        @tag.children[1].previous.should == @tag.children[0]
      end

      example 'do not set the previous element for the first element' do
        @tag.children[0].previous.should == nil
      end
    end

    context 'elements with child elements' do
      before do
        node = s(:element, nil, 'p', nil, s(:element, nil, 'span', nil, nil))
        @tag = @builder.process(node)
      end

      example 'include the name of the element' do
        @tag.name.should == 'p'
      end

      example 'include the child element' do
        @tag.children[0].is_a?(Oga::XML::Element).should == true
      end

      example 'include the name of the child element' do
        @tag.children[0].name.should == 'span'
      end
    end
  end

  context '#on_text' do
    before do
      node = s(:text, 'Hello')
      @tag = @builder.process(node)
    end

    example 'return a Text node' do
      @tag.is_a?(Oga::XML::Text).should == true
    end

    example 'include the text of the node' do
      @tag.text.should == 'Hello'
    end
  end

  context '#on_cdata' do
    before do
      node = s(:cdata, 'Hello')
      @tag = @builder.process(node)
    end

    example 'return a Cdata node' do
      @tag.is_a?(Oga::XML::Cdata).should == true
    end

    example 'include the text of the node' do
      @tag.text.should == 'Hello'
    end
  end

  context '#on_attributes' do
    before do
      @node = s(
        :attributes,
        s(:attribute, 'foo', 'bar'),
        s(:attribute, 'baz', 'wat')
      )
    end

    example 'return the attributes as a Hash' do
      @builder.process(@node).should == {'foo' => 'bar', 'baz' => 'wat'}
    end

    example 'return an empty Hash by default' do
      @builder.process(s(:attributes)).should == {}
    end
  end

  context '#handler_missing' do
    before do
      @node = s(:foo, 'bar')
    end

    example 'raise when processing an unknown node' do
      lambda { @builder.process(@node) }
        .should raise_error('No handler for node type :foo')
    end
  end
end
