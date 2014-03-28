require 'spec_helper'

describe Oga::XML::TreeBuilder do
  before do
    @builder = described_class.new
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
end
